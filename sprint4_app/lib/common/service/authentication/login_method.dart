import 'package:sprint4_app/common/service/sign_in/apple_sign_in_service.dart';
import 'package:sprint4_app/common/service/sign_in/google_sign_in_service.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_protocol.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum LoginMethod {
  apple,
  google,
  email;

  SignInProtocol? signInService() {
    switch (this) {
      case LoginMethod.apple:
        return AppleSignInService();
      case LoginMethod.google:
        return GoogleSignInService();
      case LoginMethod.email:
        return null;
    }
  }

  OAuthProvider? oAuthProvider() {
    switch (this) {
      case LoginMethod.apple:
        return OAuthProvider.apple;
      case LoginMethod.google:
        return OAuthProvider.google;
      case LoginMethod.email:
        return null;
    }
  }
}
