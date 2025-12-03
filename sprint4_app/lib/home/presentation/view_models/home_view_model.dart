import 'package:flutter/widgets.dart';
import 'package:sprint4_app/common/models/image_label_result.dart';
import 'package:sprint4_app/common/service/channels/image_labeling_service.dart';
import 'package:sprint4_app/home/data/models/home_data.dart';
import 'package:sprint4_app/home/data/repositories/home_repository.dart';

class HomeViewModel {
  final HomeRepository repository;
  final ValueNotifier<HomeData> data = ValueNotifier(HomeData());

  HomeViewModel({required this.repository});

  Future<void> fetch({bool shouldLoad = true}) async {
    if (shouldLoad) data.value = data.value.copyWith(isLoading: true);

    final homeData = await repository.fetchData();
    data.value = homeData;

    data.value = data.value.copyWith(isLoading: false);
  }

  Future<ImageLabelResult> upateImageLabelResult({
    required String filePath,
    bool isTesting = false,
  }) async {
    final currentResult = await ImageLabelingService.getLabeledImage(
      filePath: filePath,
      isTesting: isTesting,
    );

    currentResult.filePath = filePath;
    data.value = data.value.copyWith(currentResult: currentResult);

    return currentResult;
  }

  Future<void> createData() async {
    final currentResult = data.value.currentResult;
    if (currentResult == null) return;
    await repository.createResult(currentResult);
  }

  Future<void> deleteResult(ImageLabelResult result) async {
    await repository.deleteResult(result);
  }

  void resetCurrentResult() {
    final currentResult = ImageLabelResult();
    data.value = data.value.copyWith(currentResult: currentResult);
  }
}
