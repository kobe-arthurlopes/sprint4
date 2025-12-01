import 'package:sprint4_app/common/service/authentication/authentication_service_protocol.dart';
import 'package:sprint4_app/common/service/authentication/login_method.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService implements AuthenticationServiceProtocol {
  @override
  GoTrueClient? client;

  @override
  void setClient(GoTrueClient value) {
    client = value;
  }

  @override
  bool isAuthenticated = false;

  @override
  bool isSignIn = true;

  @override
  LoginMethod loginMethod = LoginMethod.email;

  @override
  String email = '';

  @override
  String password = '';

  @override
  void configureLogin({
    required bool isSignIn,
    required LoginMethod method,
    String? email,
    String? password,
  }) {
    this.isSignIn = isSignIn;
    loginMethod = method;
    if (email != null) this.email = email;
    if (password != null) this.password = password;
  }

  @override
  bool hasExistingSession() {
    final existingSession = client?.currentSession;
    isAuthenticated = existingSession != null;
    if (isAuthenticated) print('user already logged in');
    return isAuthenticated;
  }

  @override
  Future<AuthResponse?> getSignInResponse() async {
    if (client == null) {
      throw const AuthException('Client Auth invalid to get auth response');
    }

    final signInService = loginMethod.signInService();
    final oAuthProvider = loginMethod.oAuthProvider();
    final rawNonce = client!.generateRawNonce();

    if (signInService == null || oAuthProvider == null) {
      return await client!.signInWithPassword(email: email, password: password);
    }

    final idToken = await signInService.getIdToken(rawNonce: rawNonce);

    if (idToken == null) {
      throw const AuthException(
        'Could not find ID Token from generated credential.',
      );
    }

    return await client?.signInWithIdToken(
      provider: oAuthProvider,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  @override
  Future<AuthResponse?> getSignUpResponse() async {
    if (client == null) {
      throw const AuthException('Client Auth invalid to get auth response');
    }

    if (loginMethod != LoginMethod.email) {
      throw const AuthException('Wrong LoginMethod when signing up');
    }

    try {
      final signUpResponse = await client?.signUp(
        email: email,
        password: password,
      );

      if (signUpResponse == null) {
        throw const AuthException('Could not get response from sign up');
      }

      if (signUpResponse.user == null) {
        throw const AuthException('Invalid response from sign up');
      }

      return await client?.signInWithPassword(email: email, password: password);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<void> run() async {
    if (hasExistingSession()) {
      isAuthenticated = true;
      return;
    }

    try {
      final response = isSignIn
          ? await getSignInResponse()
          : await getSignUpResponse();

      if (response == null) {
        isAuthenticated = false;
        print('error -> failed to get response');
      }

      if (response?.user == null || response?.session == null) {
        isAuthenticated = false;
        print('login failed — userId: ${response!.user?.id}');
        return;
      }

      isAuthenticated = true;
      print('login succeeded — userId: ${response!.user!.id}');
    } catch (error) {
      print('error authenticating on Supabase -> $error');
    }
  }
}