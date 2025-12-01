import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/dependencies_injector.dart';
import 'package:sprint4_app/home/presentation/components/pulsing_button.dart';
import 'package:sprint4_app/home/presentation/pages/home_page.dart';
import 'package:sprint4_app/login/presentation/pages/login_page.dart';
import 'package:sprint4_app/main.dart' as app;
import 'package:supabase_flutter/supabase_flutter.dart';

Widget createTestApp() {
  final injector = DependenciesInjector(isTesting: true);

  return MultiProvider(
    providers: [
      ...injector.serviceProviders(),
      ...injector.loginProviders(),
      ...injector.homeProviders(),
    ],
    child: const app.MyApp(),
  );
}

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xrelnsmrfjvyiamzpsbp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhyZWxuc21yZmp2eWlhbXpwc2JwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0MjI1MTQsImV4cCI6MjA3ODk5ODUxNH0.TOXF9JREDosuSi-Dn34ptk0RWe-y9lNcfZ_8dONW95s',
  );

  final email = 'test@gmail.com';
  final password = '123456789';

  // testWidgets('Register user', (tester) async {
  //   await tester.pumpWidget(createTestApp());

  //   final loginFinder = find.byType(LoginPage);
  //   expect(loginFinder, findsOneWidget);

  //   final registerTextFinder = find.text('Register');
  //   expect(registerTextFinder, findsOneWidget);

  //   final registerButtonFinder = find.ancestor(
  //     of: registerTextFinder,
  //     matching: find.byType(GestureDetector),
  //   );
  //   expect(registerButtonFinder, findsOneWidget);

  //   await tester.tap(registerButtonFinder);
  //   await tester.pumpAndSettle();

  //   final emailFieldFinder = find.byKey(const Key('emailField'));
  //   expect(emailFieldFinder, findsOneWidget);

  //   await tester.tap(emailFieldFinder);
  //   await tester.pumpAndSettle();

  //   await tester.enterText(emailFieldFinder, email);
  //   await tester.pumpAndSettle();

  //   final passwordFieldFinder = find.byKey(const Key('passwordField'));
  //   expect(passwordFieldFinder, findsOneWidget);

  //   await tester.enterText(passwordFieldFinder, password);
  //   await tester.pumpAndSettle();

  // final loginButtonFinder = find.byKey(const Key('loginButtonEmail'));
  // expect(loginButtonFinder, findsOneWidget);

  // await tester.tap(loginButtonFinder);

  // await tester.pump(const Duration(milliseconds: 5000));
  // });

  testWidgets('Login and create result', (tester) async {
    await tester.pumpWidget(createTestApp());

    final loginFinder = find.byType(LoginPage);
    expect(loginFinder, findsOneWidget);

    final emailFieldFinder = find.byKey(const Key('emailField'));
    expect(emailFieldFinder, findsOneWidget);

    await tester.tap(emailFieldFinder);
    await tester.pumpAndSettle();

    await tester.enterText(emailFieldFinder, email);
    await tester.pumpAndSettle();

    final passwordFieldFinder = find.byKey(const Key('passwordField'));
    expect(passwordFieldFinder, findsOneWidget);

    await tester.tap(passwordFieldFinder);
    await tester.pumpAndSettle();

    await tester.enterText(passwordFieldFinder, password);
    await tester.pumpAndSettle();

    final loginButtonFinder = find.byKey(const Key('loginButtonEmail'));
    expect(loginButtonFinder, findsOneWidget);

    await tester.tap(loginButtonFinder);
    await tester.pumpAndSettle();

    final homeFinder = find.byType(HomePage);
    expect(homeFinder, findsOneWidget);

    final pulsingButtonFinder = find.byType(PulsingButton);
    expect(pulsingButtonFinder, findsOneWidget);

    await tester.tap(pulsingButtonFinder);
    await tester.pump();

    await tester.pump(const Duration(seconds: 5));

    final imagePickerFinder = find.byKey(const Key('imagePickerWidget'));
    expect(imagePickerFinder, findsOneWidget);

    final scaffoldFinder = find.descendant(
      of: imagePickerFinder,
      matching: find.byType(Scaffold),
    );
    expect(scaffoldFinder, findsOneWidget);

    final fabPaddingFinder = find.descendant(
      of: scaffoldFinder,
      matching: find.byKey(const Key('fabPadding')),
    );
    expect(fabPaddingFinder, findsOneWidget);

    final fabRowFinder = find.descendant(
      of: fabPaddingFinder,
      matching: find.byKey(const Key('fabRow')),
    );
    expect(fabRowFinder, findsOneWidget);

    final fabSaveFinder = find.descendant(
      of: fabRowFinder,
      matching: find.byKey(const Key('fabSave')),
    );
    expect(fabSaveFinder, findsOneWidget);

    await tester.tap(fabSaveFinder);
    await tester.pumpAndSettle();
  });
}
