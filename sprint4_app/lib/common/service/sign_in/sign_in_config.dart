import 'package:sprint4_app/common/service/sign_in/sign_in_method.dart';

class SignInConfig {
  final SignInMethod method;
  final String? email;
  final String? password;

  const SignInConfig({
    this.method = SignInMethod.email,
    this.email,
    this.password,
  });
}
