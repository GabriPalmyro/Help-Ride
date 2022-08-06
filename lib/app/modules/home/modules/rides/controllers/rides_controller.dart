import 'package:flutter/cupertino.dart';
import 'package:help_ride_web/app/helpers/constants.dart';
import 'package:help_ride_web/app/helpers/date_format.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/models/ride_model.dart';
import 'package:help_ride_web/app/shared/models/user_model.dart';

enum RidesStatus { idle, editing, success, error, loading }

class RidesController extends ChangeNotifier {
  List<RideModel> myHistoricRides = [];
  List<RideModel> myOpenRides = [];
  List<UserModel> drivers = [];
  RidesStatus _status = RidesStatus.idle;

  RidesStatus get status => _status;
  set status(RidesStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> getAllDrivers() async {
    try {
      drivers = [];
      await firebaseFirestore
          .collection('users')
          .where('isDriver', isEqualTo: true)
          .get()
          .then((value) {
        if (value.size == 0) {
          return Future.error(
              'Não foi possível encontrar motoristas cadastrados');
        }
        drivers = value.docs.map<UserModel>((driverJson) {
          Map<String, dynamic> data = driverJson.data();
          data['id'] = driverJson.id;
          return UserModel.fromJson(data);
        }).toList();
      });
    } catch (e) {
      drivers = [];
      return Future.error(e.toString());
    }
  }

  Future<void> addRide({
    required String idUser,
    required UserModel driver,
    required int passengers,
    required bool isCompleteRide,
  }) async {
    status = RidesStatus.loading;
    try {
      double priceToPay = 0.0;
      //BUSCAR INFORMAÇÕES DE CARONAS COM MOTORISTA
      Map<String, dynamic> dataRides = {};
      var snapshot = await firebaseFirestore
          .collection('users')
          .doc(idUser)
          .collection('rides')
          .doc(driver.id)
          .get();

      if (!snapshot.exists) {
        dataRides = {
          'total_rides': 0,
          'total_to_pay': 0,
        };
      } else {
        dataRides = snapshot.data() as Map<String, dynamic>;
      }

      switch (passengers) {
        case 2:
          priceToPay = driver.priceTwoPeople!;
          break;
        case 3:
          priceToPay = driver.priceThreePeople!;
          break;
        case 4:
          priceToPay = driver.priceFourPeople!;
          break;
        case 5:
          priceToPay = driver.priceFivePeople!;
          break;
        default:
          return Future.error('Número errado de passageiros');
      }

      if (!isCompleteRide) {
        priceToPay = priceToPay / 2.0;
      }

      await firebaseFirestore
          .collection('users')
          .doc(idUser)
          .collection('rides')
          .doc(driver.id)
          .set(
        {
          "name": driver.name,
          "driver_id": driver.id,
          "total_rides": dataRides['total_rides'] + 1,
          "total_to_pay": dataRides['total_to_pay'] + priceToPay,
        },
      );

      await firebaseFirestore
          .collection('users')
          .doc(idUser)
          .collection('historic_of_rides')
          .add(
        {
          "name": driver.name,
          "driverId": driver.id,
          "passengers": passengers,
          "isCompleteRide": isCompleteRide,
          "total_to_pay": priceToPay,
          "ride_date": dateFormater(DateTime.now())
        },
      );
      status = RidesStatus.success;
    } catch (e) {
      status = RidesStatus.error;
      debugPrint(e.toString());
      return Future.error('Não foi possível contabilizar sua carona');
    }
  }

  Future<void> getmyOpenRides({required String idUser}) async {
    try {
      status = RidesStatus.loading;
      notifyListeners();
      var value = await firebaseFirestore
          .collection('users')
          .doc(idUser)
          .collection('rides')
          .get();

      myOpenRides = value.docs.map<RideModel>((rideJson) {
        Map<String, dynamic> data = rideJson.data();
        data['id'] = rideJson.id;
        return RideModel.fromJson(data);
      }).toList();

      await Future.delayed(const Duration(seconds: 1));
      status = RidesStatus.success;
      debugPrint('Caronas pendentes carregadas');
    } catch (e) {
      debugPrint('Caronas pendentes carregadas FAIL');
      myOpenRides = [];
      status = RidesStatus.error;
    }
  }

  Future<bool> getMyHistoricOfRides({required String idUser}) async {
    try {
      status = RidesStatus.loading;
      await firebaseFirestore
          .collection('users')
          .doc(idUser)
          .collection('historic_of_rides')
          .orderBy('ride_date', descending: true)
          .get()
          .then((value) {
        myHistoricRides = value.docs.map<RideModel>((rideJson) {
          Map<String, dynamic> data = rideJson.data();
          data['id'] = rideJson.id;
          return RideModel.fromJson(data);
        }).toList();
      });
      status = RidesStatus.success;
      debugPrint('Histórico de caronas carregadas');
      return true;
    } catch (e) {
      debugPrint('Histórico de caronas carregadas FAIL');
      myHistoricRides = [];
      status = RidesStatus.error;
      return false;
    }
  }

  Future<String> deleteRide(
      {required String idUser,
      required String idRide,
      required double rideValue,
      required String idDriver}) async {
    try {
      status = RidesStatus.loading;
      await firebaseFirestore
          .collection('users')
          .doc(idUser)
          .collection('historic_of_rides')
          .doc(idRide)
          .delete();

      var value = await firebaseFirestore
          .collection('users')
          .doc(idUser)
          .collection('rides')
          .doc(idDriver)
          .get();

      Map<String, dynamic> data = value.data()!;
      data['id'] = value.id;
      var ride = RideModel.fromJson(data);

      ride.totalToPay = ride.totalToPay! - rideValue;
      ride.totalRides = ride.totalRides! - 1;

      await firebaseFirestore
          .collection('users')
          .doc(idUser)
          .collection('rides')
          .doc(idDriver)
          .update({
        "total_rides": ride.totalRides,
        "total_to_pay": ride.totalToPay
      });

      await getMyHistoricOfRides(idUser: idUser);

      status = RidesStatus.success;
      debugPrint('Carona deletada com sucesso');
      return 'Carona deletada com sucesso';
    } catch (e) {
      debugPrint('Carona deletada FAIL');
      status = RidesStatus.error;
      return Future.error('Não foi possível deletar carona');
    }
  }
}
