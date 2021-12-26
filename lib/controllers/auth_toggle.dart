import 'package:flutter/cupertino.dart';

class AuthToggle extends ChangeNotifier {
  bool isLogin = true;

  void toggle() {
    isLogin = !isLogin;
    notifyListeners();
  }
}
