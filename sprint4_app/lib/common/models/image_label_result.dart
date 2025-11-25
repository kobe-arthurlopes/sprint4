import 'dart:io';

import 'package:sprint4_app/common/models/prediction.dart';

class ImageLabelResult {
  final String id;
  String filePath;
  List<Prediction> predictions;
  File? file;

  ImageLabelResult({
    String? id,
    String? filePath,
    List<Prediction>? predictions,
    this.file
  }) : id = id ?? '',
       filePath = filePath ?? '',
       predictions = predictions ?? [];

  factory ImageLabelResult.fromMap(Map<String, dynamic> map) {
    return ImageLabelResult(id: map['id'], filePath: map['file_path']);
  }
}
