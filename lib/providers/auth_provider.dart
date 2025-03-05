import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners(); // UI 업데이트
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners(); // UI 업데이트
  }
}
