import 'package:flutter/material.dart';
import 'package:sprint4_app/dependencies_injector.dart';
import 'package:sprint4_app/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final depenciesInjector = DependenciesInjector();
  await depenciesInjector.inject();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = Routes();
    return MaterialApp.router(routerConfig: routes.config(context));
  }
}
