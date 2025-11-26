import 'package:flutter/material.dart';
import 'package:sprint4_app/login/data/models/login_data.dart';
import 'package:sprint4_app/login/data/repositories/login_repository.dart';

class LoginViewModel {
  final LoginRepository repository;
  final ValueNotifier<LoginData> data = ValueNotifier(LoginData());

  LoginViewModel({required this.repository});

  Future<void> login() async {
    data.value = data.value.copyWith(isLoading: true);

    try {
      await repository.login(
        email: data.value.email, 
        password: data.value.password
      );
    } catch (error) {
      final errorMessage = 'Ocorreu um problema ($error). Tente novamente';
      data.value = data.value.copyWith(errorMessage: errorMessage);
    }

    data.value = data.value.copyWith(isLoading: false);
    await repository.fetchData();
  }

  void togglePasswordVisibility() {
    final isPasswordVisible = data.value.isPasswordVisible;
    data.value = data.value.copyWith(isPasswordVisible: !isPasswordVisible);
  }
}