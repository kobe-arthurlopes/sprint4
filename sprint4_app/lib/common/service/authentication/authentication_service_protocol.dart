import 'package:sprint4_app/common/service/authentication/login_method.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthenticationServiceProtocol {
  GoTrueClient? get client;

  void setClient(GoTrueClient value);

  bool get isAuthenticated;

  bool get isSignIn;
  LoginMethod get loginMethod;
  String get email;
  String get password;

  void configureLogin({
    required bool isSignIn,
    required LoginMethod method,
    String? email,
    String? password,
  });

  bool hasExistingSession();
  Future<AuthResponse?> getSignInResponse();
  Future<AuthResponse?> getSignUpResponse();
  Future<void> signOut();
  Future<void> run();
}
