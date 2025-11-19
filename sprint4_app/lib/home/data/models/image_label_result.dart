import 'dart:io';

import 'package:sprint4_app/home/data/models/prediction.dart';

class ImageLabelResult {
  final String id;
  List<Prediction> predictions;
  File? file;

  ImageLabelResult({String? id, List<Prediction>? predictions, this.file})
    : id = id ?? '', predictions = predictions ?? [];

  factory ImageLabelResult.fromMap(Map<String, dynamic> map) {
    final filePath = map['file_path'];
    final file = filePath != null ? File(filePath) : null;

    return ImageLabelResult(
      id: map['id'],
      file: file,
    );
  }
}