import 'package:flutter/material.dart';
import 'package:help_ride_web/app/helpers/constants.dart';
import 'package:help_ride_web/app/modules/home/modules/rides/models/ride_model.dart';
import 'package:help_ride_web/app/shared/models/user_model.dart';

enum ReceivableStatus { idle, success, error, loading, editing }

class ReceivableController extends ChangeNotifier {
  ReceivableStatus _status = ReceivableStatus.idle;

  List<RideModel> myReceveibleRides = [];
  double totalToReceive = 0.0;

  ReceivableStatus get status => _status;
  set status(ReceivableStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> getReceivableRides({
    required String idUser,
  }) async {
    status = ReceivableStatus.loading;
    myReceveibleRides = [];
    totalToReceive = 0.0;
    try {
      var response = await firebaseFirestore.collection('users').get();

      var passengers = response.docs.map<UserModel>((driverJson) {
        Map<String, dynamic> data = driverJson.data();
        data['id'] = driverJson.id;
        return UserModel.fromJson(data);
      }).toList();

      for (var i = 0; i < passengers.length; i++) {
        var value = await firebaseFirestore
            .collection('users')
            .doc(passengers[i].id)
            .collection('rides')
            .get();

        for (var ride in value.docs) {
          Map<String, dynamic> data = ride.data();
          if (ride.id == idUser) {
            data['id'] = ride.id;
            data['name'] = passengers[i].name;
            var rideTemp = RideModel.fromJson(data);
            totalToReceive = totalToReceive + rideTemp.totalToPay!;
            myReceveibleRides.add(rideTemp);
          }
        }
      }

      status = ReceivableStatus.success;
    } catch (e) {
      myReceveibleRides = [];
      totalToReceive = 0.0;
      status = ReceivableStatus.error;
      debugPrint(e.toString());
      return Future.error('Não foi possível recuperar pagamentos a receber');
    }
  }
}
