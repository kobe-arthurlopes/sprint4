import 'package:sprint4_app/common/models/image_label_result.dart';

class HomeData {
  List<ImageLabelResult> results;
  ImageLabelResult? currentResult;
  bool isLoading;
  bool shouldShowBottomSheet;

  HomeData({
    this.results = const [],
    this.currentResult,
    this.isLoading = true,
    this.shouldShowBottomSheet = true
  });

  HomeData copyWith({
    List<ImageLabelResult>? results,
    ImageLabelResult? currentResult,
    bool? isLoading,
    bool? shouldShowBottomSheet,
  }) {
    return HomeData(
      results: results ?? this.results,
      currentResult: currentResult ?? this.currentResult,
      isLoading: isLoading ?? this.isLoading,
      shouldShowBottomSheet: shouldShowBottomSheet ?? this.shouldShowBottomSheet,
    );
  }
}