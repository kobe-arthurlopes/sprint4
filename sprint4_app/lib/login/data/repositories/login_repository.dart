import 'package:sprint4_app/common/service/sign_in/sign_in_config.dart';
import 'package:sprint4_app/login/data/data_sources/login_data_source.dart';
import 'package:sprint4_app/login/data/models/login_data.dart';

class LoginRepository {
  final LoginDataSource dataSource;

  LoginRepository({required this.dataSource});

  Future<void> login({required SignInConfig? config}) async {
    if (config == null) {
      throw Exception('Unimplemented sign in configuration');
    }

    await dataSource.login(config);
  }

  Future<LoginData> fetchData() async {
    return await dataSource.fetch();
  }
}