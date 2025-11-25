import 'package:sprint4_app/common/service/authentication/authentication_service_protocol.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_method.dart';
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
  SignInMethod signInMethod = SignInMethod.emailPassword;

  @override
  String email = '';

  @override
  String password = '';

  @override
  void configureSignIn({required SignInMethod method, String? email, String? password}) {
    signInMethod = method;

    if (email != null) this.email = email;
    if (password != null) this.password = password;
  }

  @override
  bool hasExistingSession() {
    final existingSession = client?.currentSession;
    isAuthenticated = existingSession != null;
    return isAuthenticated;
  }

  @override
  Future<AuthResponse> getResponse() async {
    if (client == null) {
      throw const AuthException(
        'Client Auth invalid to get auth response',
      );
    }

    final signInService = signInMethod.signInService();
    final oAuthProvider = signInMethod.oAuthProvider();
    final rawNonce = client!.generateRawNonce();

    if (signInService == null || oAuthProvider == null) {
      return await client!.signInWithPassword(
        email: email,
        password: password,
      );
    }

    final idToken = await signInService.getIdToken(rawNonce: rawNonce);

    if (idToken == null) {
      throw const AuthException(
        'Could not find ID Token from generated credential.',
      );
    }

    return await client!.signInWithIdToken(
      provider: oAuthProvider,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  @override
  Future<void> run() async {
    try {
      final response = await getResponse();

      if (response.user != null && response.session != null) {
        isAuthenticated = true;
        print("login succeeded — userId: ${response.user!.id}");
        return;
      }

      isAuthenticated = false;
      print("login failed — userId: ${response.user?.id}");
    } catch (error) {
      print('error authenticating on Supabase -> $error');
    }
  }
}