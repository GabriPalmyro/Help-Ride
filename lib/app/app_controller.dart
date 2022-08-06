import 'package:flutter/material.dart';

enum AppState { idle, success, error, loading }

class AppController extends ChangeNotifier {
  AppState _appState = AppState.idle;

  AppState get appState => _appState;

  set appState(userState) {
    _appState = appState;
    notifyListeners();
  }
}
