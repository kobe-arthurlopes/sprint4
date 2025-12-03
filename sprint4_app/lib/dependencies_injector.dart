import 'package:provider/provider.dart';
import 'package:sprint4_app/common/service/image/image_service.dart';
import 'package:sprint4_app/common/service/image/image_service_protocol.dart';
import 'package:sprint4_app/login/data/data_sources/login_data_source.dart';
import 'package:sprint4_app/login/data/repositories/login_repository.dart';
import 'package:sprint4_app/login/presentation/view_models/login_view_model.dart';
import 'package:sprint4_app/common/service/authentication/authentication_service.dart';
import 'package:sprint4_app/common/service/authentication/authentication_service_protocol.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';
import 'package:sprint4_app/home/data/data_sources/home_remote_data_source.dart';
import 'package:sprint4_app/home/data/repositories/home_repository.dart';
import 'package:sprint4_app/home/presentation/view_models/home_view_model.dart';

class DependenciesInjector {
  const DependenciesInjector();

  List<Provider> serviceProviders() {
    return [
      Provider<AuthenticationServiceProtocol>(
        create: (_) => AuthenticationService(),
      ),
      Provider<SupabaseServiceProtocol>(
        create: (context) => SupabaseService(authentication: context.read<AuthenticationServiceProtocol>()),
      ),
    ];
  }

  List<Provider> loginProviders() {
    return [
      Provider<LoginDataSource>(
        create: (context) => LoginDataSource(supabaseService: context.read<SupabaseServiceProtocol>()),
      ),
      Provider<LoginRepository>(
        create: (context) => LoginRepository(dataSource: context.read<LoginDataSource>()),
      ),
      Provider<LoginViewModel>(
        create: (context) => LoginViewModel(repository: context.read<LoginRepository>()),
      ),
    ];
  }

  List<Provider> homeProviders() {
    return [
      Provider<HomeRemoteDataSource>(
        create: (context) => HomeRemoteDataSource(supabaseService: context.read<SupabaseServiceProtocol>()),
      ),
      Provider<HomeRepository>(
        create: (context) => HomeRepository(remote: context.read<HomeRemoteDataSource>()),
      ),
      Provider<HomeViewModel>(
        create: (context) => HomeViewModel(repository: context.read<HomeRepository>()),
      ),
      Provider<ImageServiceProtocol>(
        create: (_) {
          return ImageService();
        },
      ),
    ];
  }
}