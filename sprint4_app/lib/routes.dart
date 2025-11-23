import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sprint4_app/home/data/repositories/home_repository.dart';
import 'package:sprint4_app/home/presentation/pages/home_page.dart';
import 'package:sprint4_app/home/presentation/view_models/home_view_model.dart';

// Configuração do GoRouter
GoRouter router(HomeRepository homeRepo) {
  return GoRouter(
    initialLocation: '/',
    routes: [
    GoRoute(
          path: '/',
          builder: (context, state) => HomePage(viewModel: HomeViewModel(repository: context.read()))
      ),
    ]
  );
}