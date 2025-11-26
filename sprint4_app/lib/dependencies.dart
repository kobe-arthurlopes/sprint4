import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/login/presentation/view_models/login_view_model.dart';
import 'package:sprint4_app/common/service/authentication/authentication_service.dart';
import 'package:sprint4_app/common/service/authentication/authentication_service_protocol.dart';
import 'package:sprint4_app/common/service/sign_in/sign_in_method.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';
import 'package:sprint4_app/home/data/data_sources/home_remote_data_source.dart';
import 'package:sprint4_app/home/data/repositories/home_repository.dart';
import 'package:sprint4_app/home/presentation/view_models/home_view_model.dart';
import 'package:sprint4_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> injectDependencies() async {
  await Supabase.initialize(
    url: 'https://xrelnsmrfjvyiamzpsbp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhyZWxuc21yZmp2eWlhbXpwc2JwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0MjI1MTQsImV4cCI6MjA3ODk5ODUxNH0.TOXF9JREDosuSi-Dn34ptk0RWe-y9lNcfZ_8dONW95s',
  );

  runApp(
    MultiProvider(
      providers: [

        Provider<AuthenticationServiceProtocol>(
          create: (context) => AuthenticationService()),
        ChangeNotifierProvider<SupabaseServiceProtocol>(
          create: (context) => SupabaseService(authentication: context.read()),
        ),
        ChangeNotifierProvider<HomeRemoteDataSource>(
          create: (context) =>
              HomeRemoteDataSource(supabaseService: context.read()),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(supabaseService: context.read())
        ),
        ChangeNotifierProvider<HomeRepository>(
          create: (context) => HomeRepository(remote: context.read()),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(repository: context.read()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}