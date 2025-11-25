import 'package:sprint4_app/common/service/sign_in/apple_sign_in_service.dart';
import 'package:sprint4_app/common/service/sign_in/google_sign_in_service.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_protocol.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SignInMethod {
  apple,
  google,
  unknown;

  SignInProtocol signInService() {
    switch (this) {
      case SignInMethod.apple:
        return AppleSignInService();
      case SignInMethod.google:
        return GoogleSignInService();
      case SignInMethod.unknown:
        return GoogleSignInService();
    }
  }

  OAuthProvider oAuthProvider() {
    switch (this) {
      case SignInMethod.apple:
        return OAuthProvider.apple;
      case SignInMethod.google:
        return OAuthProvider.google;
      case SignInMethod.unknown:
        return OAuthProvider.google;
    }
  }
}
