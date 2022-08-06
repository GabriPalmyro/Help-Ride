import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_ride_web/app/helpers/constants.dart';

import 'package:help_ride_web/app/shared/models/user_model.dart';
import 'package:help_ride_web/app/shared/services/shared_local_preferences.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  editing
}

const String users = "users";

class AuthController extends ChangeNotifier {
  final SharedLocalStorageService _sharedLocalStorageService;

  User? _user;
  Status _status = Status.uninitialized;

  UserModel _userModel = UserModel();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
    clientId:
        '706029459731-qkcekdpab9magbbnuukhj8esg2ng04l1.apps.googleusercontent.com',
  );

  UserModel get userModel => _userModel;
  Status get status => _status;
  User? get user => _user;

  set userModel(UserModel user) {
    _userModel = user;
    notifyListeners();
  }

  set status(Status status) {
    _status = status;
    notifyListeners();
  }

  AuthController.init(this._sharedLocalStorageService) {
    _fireSetUp();
  }

  _fireSetUp() async {
    await initialization.then((value) {
      auth.authStateChanges().listen(_onStateChange);
    });
  }

  Future signInWithGoogle() async {
    try {
      status = Status.authenticating;

      final googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredentials = await auth.signInWithCredential(credential);

      _user = userCredentials.user;
      await _sharedLocalStorageService.put('id', _user!.uid);

      if (!await doesUserExists(_user!.uid)) {
        createUser(
          id: _user!.uid,
          name: _user!.displayName!,
          photo: _user!.photoURL!,
          email: _user!.email!,
        );
      }

      await initializeUserModel();

      status = Status.authenticated;
    } catch (e) {
      await _sharedLocalStorageService.delete('id');
      status = Status.unauthenticated;
      debugPrint(e.toString());
      return Future.error(e.toString());
    }
  }

  Future<bool> initializeUserModel() async {
    String userId = await _sharedLocalStorageService.get('id');
    debugPrint('ID USER: $userId');
    _userModel = await getUserById(userId);
    debugPrint(_userModel.toString());
    notifyListeners();
    if (_userModel.id == null) {
      await _sharedLocalStorageService.delete('id');
      return Future.error(false);
    } else {
      return true;
    }
  }

  void createUser({
    required String id,
    required String name,
    required String photo,
    required String email,
  }) async {
    firebaseFirestore.collection(users).doc(id).set({
      "name": name,
      "email": email,
      "photo": photo,
      "created_at": DateTime.now()
    });
  }

  Future<bool> doesUserExists(String id) async => firebaseFirestore
      .collection(users)
      .doc(id)
      .get()
      .then((value) => value.exists);

  Future<UserModel> getUserById(String id) =>
      firebaseFirestore.collection(users).doc(id).get().then((value) {
        Map<String, dynamic> data = value.data() as Map<String, dynamic>;
        data['id'] = id;
        return UserModel.fromJson(data);
      });

  Future signOut() async {
    auth.signOut();
    await _sharedLocalStorageService.delete('id');
    status = Status.unauthenticated;
    return Future.delayed(Duration.zero);
  }

  Future<void> updateProfileUser({required UserModel userModelNew}) async {
    status = Status.editing;
    try {
      firebaseFirestore.collection(users).doc(userModelNew.id).update(
        {
          "name": userModelNew.name,
          "email": userModelNew.email,
          "isDriver": userModelNew.isDriver,
          "pixCode": userModelNew.pixCode,
          'priceTwoPeople': userModelNew.priceTwoPeople,
          'priceThreePeople': userModelNew.priceThreePeople,
          'priceFourPeople': userModelNew.priceFourPeople,
          'priceFivePeople': userModelNew.priceFivePeople,
        },
      );
      userModel = userModelNew;
      status = Status.authenticated;
    } catch (e) {
      status = Status.authenticated;
      debugPrint(e.toString());
      return Future.error('Não foi possível atualizar o seu cadastro');
    }
  }

  _onStateChange(User? firebaseUser) async {
    if (firebaseUser == null) {
      status = Status.unauthenticated;
    } else {
      _user = firebaseUser;
      initializeUserModel();
      Future.delayed(const Duration(seconds: 1), () {
        status = Status.authenticated;
      });
    }
  }
}
