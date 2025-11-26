import 'package:sprint4_app/common/service/sign_in/sign_in_config.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';

class LoginDataSource {
  final SupabaseServiceProtocol supabaseService;

  LoginDataSource({required this.supabaseService});

  Future<bool> login(SignInConfig config) async {
    supabaseService.authentication.configureSignIn(
      method: config.method,
      email: config.email,
      password: config.password,
    );

    await supabaseService.authentication.run();
    return supabaseService.authentication.isAuthenticated;
  }
}