import 'package:go_router/go_router.dart';
import 'package:sprint4_app/home/presentation/pages/home_page.dart';
import 'package:sprint4_app/login/presentation/pages/login_page.dart';

class Routes {
  // Configuração do GoRouter
  GoRouter config({String initialLocation = '/login'}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: LoginPage.routeId,
          builder: (_, _) => LoginPage()
        ),
        GoRoute(
          path: HomePage.routeId,
          builder: (_, _) => HomePage()   
        ),
      ]
    );
  }
}