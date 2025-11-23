import 'package:sprint4_app/home/data/repositories/home_repository.dart';

class HomeViewModel {
  final HomeRepository repository;

  HomeViewModel({required this.repository});

  Future<void> fetch() async {
    // final results = await repository.fetchData();
  }
}