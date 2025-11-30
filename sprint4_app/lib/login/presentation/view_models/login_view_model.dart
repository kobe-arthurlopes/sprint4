import 'package:flutter/material.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_config.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_method.dart';
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
      isAuthenticated = await repository.login(config: data.value.signInConfig);
    } catch (error) {
      final errorMessage = 'Ocorreu um problema ($error). Tente novamente';
      data.value = data.value.copyWith(errorMessage: errorMessage);
    }

    data.value = data.value.copyWith(isLoading: false);
    return isAuthenticated;
  }

  void configureSignIn({
    required SignInMethod method,
    String? email,
    String? password,
  }) {
    final config = SignInConfig(
      method: method,
      email: email,
      password: password,
    );

    data.value = data.value.copyWith(signInConfig: config);
  }

  void togglePasswordVisibility() {
    final isPasswordVisible = data.value.isPasswordVisible;
    data.value = data.value.copyWith(isPasswordVisible: !isPasswordVisible);
  }
}