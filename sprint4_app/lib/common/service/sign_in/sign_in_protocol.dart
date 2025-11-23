abstract class SignInProtocol {
  Future<String?> getIdToken({required String rawNonce});
}
