import 'package:flutter/material.dart';
import 'package:help_ride_web/app/helpers/constants.dart';

enum ProfileStatus { idle, editing, success, error, loading }

class ProfileController extends ChangeNotifier {
  ProfileStatus _status = ProfileStatus.idle;

  ProfileStatus get status => _status;
  set status(ProfileStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<void> updateProfileUser({
    required String id,
    required String name,
    required String email,
    required bool isDriver,
  }) async {
    status = ProfileStatus.editing;
    try {
      firebaseFirestore.collection('users').doc(id).update(
        {"name": name, "email": email, "isDriver": isDriver},
      );
      _status = ProfileStatus.success;
    } catch (e) {
      status = ProfileStatus.error;
      debugPrint(e.toString());
      return Future.error('Não foi possível atualizar o seu cadastro');
    }
  }
}
