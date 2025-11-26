import 'package:sprint4_app/common/service/sign_in/sign_in_config.dart';
import 'package:sprint4_app/login/data/data_sources/login_data_source.dart';

class LoginRepository {
  final LoginDataSource dataSource;

  LoginRepository({required this.dataSource});

  Future<bool> login({required SignInConfig? config}) async {
    if (config == null) {
      throw Exception('Unimplemented sign in configuration');
    }

    return await dataSource.login(config);
  }
}