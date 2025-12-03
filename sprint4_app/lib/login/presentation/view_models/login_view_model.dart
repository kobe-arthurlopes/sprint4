import 'package:flutter/material.dart';
import 'package:sprint4_app/common/service/authentication/login_method.dart';
import 'package:sprint4_app/login/data/models/login_data.dart';
import 'package:sprint4_app/login/data/repositories/login_repository.dart';

class LoginViewModel {
  final LoginRepository repository;
  final ValueNotifier<LoginData> data = ValueNotifier(LoginData());

  LoginViewModel({required this.repository});

  Future<bool> login() async {
    data.value = data.value.copyWith(isLoading: true);

    bool isAuthenticated = false;

    try {
      isAuthenticated = await repository.login(data.value);
    } catch (error) {
      final errorMessage = 'An error has occured ($error). Please try again';
      data.value = data.value.copyWith(errorMessage: errorMessage);
    }

    data.value = data.value.copyWith(isLoading: false);
    return isAuthenticated;
  }

  void setMethod(LoginMethod value) {
    data.value = data.value.copyWith(method: value);
  }

  void setEmail(String? value) {
    data.value = data.value.copyWith(email: value);
  }

  void setPassword(String? value) {
    data.value = data.value.copyWith(password: value);
  }

  void togglePasswordVisibility() {
    final isPasswordVisible = data.value.isPasswordVisible;
    data.value = data.value.copyWith(isPasswordVisible: !isPasswordVisible);
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please, enter your password';
    }

    if (password.length < 6) {
      return 'Password must have at least 6 characters';
    }

    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please, enter your email';
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please, enter a valid email';
    }

    return null;
  }

  void toggleIsSignIn() {
    final isSignIn = data.value.isSignIn;
    data.value = data.value.copyWith(isSignIn: !isSignIn);
  }
}
