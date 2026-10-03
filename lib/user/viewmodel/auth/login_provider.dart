import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final loginProvider =
    ChangeNotifierProvider<LoginProvider>((ref) {
  return LoginProvider();
});

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool obscure = true;

  void togglePassword() {
    obscure = !obscure;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}