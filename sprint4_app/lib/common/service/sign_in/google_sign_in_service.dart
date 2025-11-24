import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_protocol.dart';

class GoogleSignInService implements SignInProtocol {
  @override
  Future<String?> getIdToken({String? rawNonce}) async {
    const webClientId =
        '72772928328-ftfj73lh337k2e3g5u50gn9qrpfo436q.apps.googleusercontent.com';

    const iosClientId =
        '72772928328-7ku5bpb4s8t5m89ose46fsqcstp9mqhr.apps.googleusercontent.com';

    final GoogleSignIn signIn = GoogleSignIn.instance;

    unawaited(
      signIn.initialize(clientId: iosClientId, serverClientId: webClientId),
    );

    final googleAccount = await signIn.authenticate();
    final googleAuthentication = googleAccount.authentication;
    return googleAuthentication.idToken;
  }
}
