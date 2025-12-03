import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';
import 'package:sprint4_app/dependencies_injector.dart';
import 'package:sprint4_app/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final depenciesInjector = DependenciesInjector();

  await Supabase.initialize(
    url: 'https://xrelnsmrfjvyiamzpsbp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhyZWxuc21yZmp2eWlhbXpwc2JwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0MjI1MTQsImV4cCI6MjA3ODk5ODUxNH0.TOXF9JREDosuSi-Dn34ptk0RWe-y9lNcfZ_8dONW95s',
  );

  runApp(
    MultiProvider(
      providers: [
        ...depenciesInjector.serviceProviders(),
        ...depenciesInjector.loginProviders(),
        ...depenciesInjector.homeProviders(),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseServiceProtocol supabaseService = context
        .read<SupabaseServiceProtocol>();

    final initialRouterLocation =
        supabaseService.authentication.hasExistingSession()
        ? '/home'
        : '/login';

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      routerConfig: Routes().config(initialLocation: initialRouterLocation),
    );
  }
}
