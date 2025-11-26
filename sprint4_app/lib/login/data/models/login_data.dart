import 'package:sprint4_app/common/service/sign_in/sign_in_config.dart';

class LoginData {
  bool isPasswordVisible;
  bool isLoading;
  bool isAuthenticated;
  SignInConfig? signInConfig;
  String? errorMessage;

  LoginData({
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.signInConfig,
    this.errorMessage,
  });

  LoginData copyWith({
    bool? isPasswordVisible,
    bool? isLoading,
    bool? isAuthenticated,
    SignInConfig? signInConfig,
    String? errorMessage,
  }) {
    return LoginData(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      signInConfig: signInConfig ?? this.signInConfig,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}