import 'package:flutter/material.dart';

class PasswordInterface extends ChangeNotifier {
  bool isPasswordVisable = true;

  bool getPasswordVisable() {
    return isPasswordVisable;
  }

  void changePasswordVisable() {
    if (isPasswordVisable) {
      isPasswordVisable = false;
    } else {
      isPasswordVisable = true;
    }
    ;
    notifyListeners();
  }
}
