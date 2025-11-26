import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/common/login/presentation/pages/login_page.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';
import 'package:sprint4_app/home/presentation/pages/home_page.dart';

// Configuração do GoRouter
GoRouter router(BuildContext context) {
  final SupabaseServiceProtocol supabaseService = context.read();
  String initialScreen = '/login';
  if (supabaseService.authentication.isAuthenticated) {
    initialScreen = '/';
  }
  return GoRouter(
    initialLocation: initialScreen,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(viewModel: context.read())   
      ),
      GoRoute(path: '/login',
      builder: (context, state) => LoginPage(viewModel: context.read())
      )
    ]
  );
}