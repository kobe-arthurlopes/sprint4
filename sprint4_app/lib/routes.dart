import 'package:go_router/go_router.dart';
import 'package:sprint4_app/common/models/prediction.dart';
import 'package:sprint4_app/home/presentation/pages/home_page.dart';
import 'package:sprint4_app/home/presentation/pages/image_description_page.dart';
import 'package:sprint4_app/login/presentation/pages/login_page.dart';

class Routes {
  // Configuração do GoRouter
  GoRouter config({String initialLocation = '/login'}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: LoginPage.routeId, builder: (_, _) => LoginPage()),
        GoRoute(path: HomePage.routeId, builder: (_, _) => HomePage()),
        GoRoute(
          path: ImageDescriptionPage.routeId,
          builder: (_, state) {
            final args = state.extra as ImageDescriptionArgs;

            List<Prediction> predictions = [];
            predictions.addAll(args.predictions);
            predictions.addAll(args.predictions);
            predictions.addAll(args.predictions);
            predictions.addAll(args.predictions);
            predictions.addAll(args.predictions);
            predictions.addAll(args.predictions);
            predictions.addAll(args.predictions);
            predictions.addAll(args.predictions);

            return ImageDescriptionPage(
              imageFile: args.imageFile,
              predictions: predictions,
              onSave: args.onSave,
            );
          },
        ),
      ],
    );
  }
}
