import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/dependencies.dart';
import 'package:sprint4_app/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injectDependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router(context));
  }
}
