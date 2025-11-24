import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sprint4_app/home/data/models/image_label_result.dart';
import 'package:sprint4_app/home/data/models/label.dart';
import 'package:sprint4_app/home/data/models/prediction.dart';
import 'package:sprint4_app/common/service/image_labeling_service.dart';
import 'package:sprint4_app/home/data/repositories/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeRepository repository;

  HomeViewModel({required this.repository});

  ImageLabelResult imageLabelResult = ImageLabelResult();
  bool isLoading = false;
  List<ImageLabelResult> results = [];

  Future<void> fetch() async {
    results = await repository.fetchData();
    notifyListeners();
  }

  Future<void> upateImageLabelResult(File imageFile) async {
    imageLabelResult = await ImageLabelingService.getLabeledImage(imageFile);
    notifyListeners();
  }

  Future<void> createData() async {
    await repository.createData(imageLabelResult);
  }

  Future<void> refreshResults() async {
    isLoading = true;
    notifyListeners();

    await fetch();

    isLoading = false;
    notifyListeners();
  }
}