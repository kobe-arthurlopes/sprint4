import 'package:sprint4_app/login/data/data_sources/login_data_source.dart';
import 'package:sprint4_app/login/data/models/login_data.dart';

class LoginRepository {
  final LoginDataSource dataSource;

  LoginRepository({required this.dataSource});

  Future<bool> login(LoginData data) async {
    return await dataSource.login(data);
  }
}
