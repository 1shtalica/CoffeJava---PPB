import 'package:e_nusantara/api/auth_service.dart';
import 'package:e_nusantara/screens/sign_in.dart';
import 'package:flutter/material.dart';

class Checklogin {
  Future<void> checkAndNavigate(BuildContext context) async {
    final AuthService _authService = AuthService();
    bool isLogin = await _authService.checkToken();
    if (!isLogin) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const SignInPage(title: "sign in")));
      return;
    }
  }
}
