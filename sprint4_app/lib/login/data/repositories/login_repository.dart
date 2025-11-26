import 'package:sprint4_app/login/data/data_sources/login_data_source.dart';
import 'package:sprint4_app/login/data/models/login_data.dart';

class LoginRepository {
  final LoginDataSource dataSource;

  LoginRepository({required this.dataSource});

  Future<void> login({required String email, required String password}) async {
    await dataSource.login(email: email, password: password);
  }

  Future<LoginData> fetchData() async {
    return await dataSource.fetch();
  }
}