import 'package:sprint4_app/common/service/authentication/login_method.dart';

class LoginData {
  bool isPasswordVisible;
  bool isLoading;
  LoginMethod method;
  String? email;
  String? password;
  String? errorMessage;
  bool isSignIn;

  LoginData({
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.method = LoginMethod.email,
    this.email,
    this.password,
    this.errorMessage,
    this.isSignIn = true,
  });

  LoginData copyWith({
    bool? isPasswordVisible,
    bool? isLoading,
    bool? isAuthenticated,
    LoginMethod? method,
    String? email,
    String? password,
    String? errorMessage,
    bool? isSignIn,
  }) {
    return LoginData(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      method: method ?? this.method,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      isSignIn: isSignIn ?? this.isSignIn,
    );
  }
}
