import 'package:flutter/material.dart';
import 'package:sprint4_app/data/models/image_label_result.dart';
import 'package:sprint4_app/data/repositories/list_repository.dart';

class ListViewModel extends ChangeNotifier {
  final ListRepository repository;

  ListViewModel({required this.repository});
  bool showBottomSheet = true;

  Future<List<ImageLabelResult>> fetch() async {
    final results = await repository.fetchData();
    print(results[0].file ?? 'sem arquivo');
    return results;
  }
}