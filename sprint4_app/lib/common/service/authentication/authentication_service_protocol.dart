import 'package:sprint4_app/common/service/sign_in/sign_in_method.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthenticationServiceProtocol {
  GoTrueClient? get client;

  void setClient(GoTrueClient value);

  bool get isAuthenticated;

  SignInMethod get signInMethod;
  String get email;
  String get password;

  void configureSignIn({required SignInMethod method, String? email, String? password});

  bool hasExistingSession();
  Future<AuthResponse> getResponse();
  Future<void> run();
}