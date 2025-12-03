import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_protocol.dart';

class GoogleSignInService implements SignInProtocol {
  @override
  Future<String?> getIdToken({String? rawNonce}) async {
    const webClientId =
        '72772928328-pdlq8ubo216bjdtl0hus3vqrok6fvrsb.apps.googleusercontent.com';

    const iosClientId =
        '72772928328-3qr2v9f56s22v022170ivhilt7eqmi12.apps.googleusercontent.com';

    final GoogleSignIn signIn = GoogleSignIn.instance;

    unawaited(
      signIn.initialize(clientId: iosClientId, serverClientId: webClientId),
    );

    final googleAccount = await signIn.authenticate();
    final googleAuthentication = googleAccount.authentication;
    return googleAuthentication.idToken;
  }
}
