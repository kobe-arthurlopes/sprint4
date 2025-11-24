import 'package:flutter/material.dart';
import 'package:sprint4_app/data/repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository repository;

  HomeViewModel({required this.repository});
  bool showBottomSheet = true;

  Future<void> fetch() async {
    final results = await repository.fetchData();
  }

  void hideBottomSheet() {
    showBottomSheet = false;
    notifyListeners();
  }

  void appearBottomSheet() {
    showBottomSheet = true;
    notifyListeners();
  }
}