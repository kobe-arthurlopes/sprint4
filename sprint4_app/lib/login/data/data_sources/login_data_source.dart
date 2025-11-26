import 'package:sprint4_app/common/service/sign_in/sign_in_method.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';
import 'package:sprint4_app/login/data/models/login_data.dart';

class LoginDataSource {
  final SupabaseServiceProtocol supabaseService;

  LoginDataSource({required this.supabaseService});

  Future<void> login({required String email, required String password}) async {
    supabaseService.authentication.configureSignIn(
      method: SignInMethod.emailPassword,
      email: email, // mocked.email@gmail.com
      password: password, // 1234
    );

    await supabaseService.authentication.run();
  }

  Future<LoginData> fetch() async {
    final isAuthenticated = supabaseService.authentication.isAuthenticated;
    return LoginData(isAuthenticated: isAuthenticated);
  }
}