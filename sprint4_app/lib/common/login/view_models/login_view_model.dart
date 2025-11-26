import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_method.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';

class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final SupabaseServiceProtocol supabaseService;
  bool isPasswordVisible = false;
  bool isLoading = false;

  LoginViewModel({required this.supabaseService});

  Future<bool> handleLogin() async {
    if (!formKey.currentState!.validate()) return false;

    isLoading = true;
    notifyListeners();

    final email = emailController.text;
    final password = passwordController.text;

    supabaseService.authentication.configureSignIn(
      method: SignInMethod.emailPassword,
      email: email, //'mocked.email@gmail.com'
      password: password //1234
    );

    await supabaseService.authentication.run();
    isLoading = false;
    notifyListeners();
    if (supabaseService.authentication.isAuthenticated) {
      return true;
    }
    return false;
  }
}