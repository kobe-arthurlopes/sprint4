import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';
import 'package:sprint4_app/login/data/models/login_data.dart';

class LoginDataSource {
  final SupabaseServiceProtocol supabaseService;

  LoginDataSource({required this.supabaseService});

  Future<bool> login(LoginData data) async {
    supabaseService.authentication.configureLogin(
      isSignIn: data.isSignIn,
      method: data.method,
      email: data.email,
      password: data.password,
    );

    await supabaseService.authentication.run();
    return supabaseService.authentication.isAuthenticated;
  }
}
