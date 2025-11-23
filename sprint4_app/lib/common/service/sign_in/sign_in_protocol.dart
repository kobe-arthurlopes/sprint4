abstract class SignInProtocol {
  Future<String?> getIdToken({String? rawNonce});
}
