import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_protocol.dart';

class AppleSignInService implements SignInProtocol {
  @override
  Future<String?> getIdToken({required rawNonce}) async {
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    return credential.identityToken;
  }
}
