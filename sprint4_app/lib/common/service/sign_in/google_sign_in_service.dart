import 'package:sprint4_app/common/service/sign_in/sign_in_protocol.dart';

class GoogleSignInService implements SignInProtocol {
  @override
  Future<String?> getIdToken({required String rawNonce}) async {
    return await null;
  }
}
