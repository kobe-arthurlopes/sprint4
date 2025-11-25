import 'package:flutter/material.dart';
import 'package:sprint4_app/home/data/models/image_label_result.dart';
import 'package:sprint4_app/common/service/image_labeling_service.dart';
import 'package:sprint4_app/home/data/repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository repository;

  HomeViewModel({required this.repository});

  ImageLabelResult currentResult = ImageLabelResult();
  bool isLoading = false;
  List<ImageLabelResult> results = [];
  bool shouldShowBottomSheet = true;

  Future<void> fetch() async {
    results = await repository.fetchData();
    notifyListeners();
  }

  Future<void> upateImageLabelResult(String filePath) async {
    currentResult = await ImageLabelingService.getLabeledImage(filePath);
    currentResult.filePath = filePath;
    notifyListeners();
  }

  Future<void> createData() async {
    await repository.createResult(currentResult);
  }

  Future<void> refreshResults() async {
    _startLoading();
    await fetch();
    _stopLoading();
  }

  void _startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void _stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void resetCurrentResult() {
    currentResult = ImageLabelResult();
    notifyListeners();
  }

  void updateShouldShowBottomSheet({required bool value}) {
    shouldShowBottomSheet = value;
    notifyListeners();
  }
}
