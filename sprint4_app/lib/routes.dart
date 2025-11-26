import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';
import 'package:sprint4_app/home/presentation/pages/home_page.dart';
import 'package:sprint4_app/login/presentation/pages/login_page.dart';

class Routes {
  // Configuração do GoRouter
  GoRouter config(BuildContext context) {
    final SupabaseServiceProtocol supabaseService = context.read<SupabaseServiceProtocol>();
    String initialScreen = '/login';

    if (supabaseService.authentication.isAuthenticated) {
      initialScreen = HomePage.routeId;
    }

    return GoRouter(
      initialLocation: initialScreen,
      routes: [
        GoRoute(
          path: HomePage.routeId,
          builder: (_, _) => HomePage()   
        ),
        GoRoute(
          path: LoginPage.routeId,
          builder: (_, _) => LoginPage()
        )
      ]
    );
  }
}