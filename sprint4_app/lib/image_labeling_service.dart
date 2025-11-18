import 'dart:io';
import 'package:flutter/services.dart';

class ImageLabelingService {
  static const _channel = MethodChannel('com.sprint4/image_labeling');

  static Future<ImageLabelResult> getLabeledImage(File? file) async {
    if (file == null) return ImageLabelResult();

    final assetPath = file.path;
    final bytes = await rootBundle.load(assetPath);
    final list = bytes.buffer.asUint8List();
    final result = await _channel.invokeMethod('labelImage', {'bytes': list});

    final predictions = (result as List)
        .map(
          (element) => Prediction.fromMap(Map<String, dynamic>.from(element)),
        )
        .toList();

    return ImageLabelResult(predictions: predictions, file: file);
  }
}

class ImageLabelResult {
  List<Prediction> predictions;
  File? file;

  ImageLabelResult({List<Prediction>? predictions, this.file})
    : predictions = predictions ?? [];
}

class Prediction {
  final Label label;
  final double confidenceDecimal;
  final String confidenceText;

  Prediction({
    required this.label,
    required this.confidenceDecimal,
    required this.confidenceText,
  });

  factory Prediction.fromMap(Map<String, dynamic> map) {
    final labelText = map['text'];
    final labelIndex = map['index'];
    final Label label = Label(text: labelText, index: labelIndex);
    final confidenceDecimal = map['confidence'];
    final confidenceText = '${(confidenceDecimal * 100).toStringAsFixed(2)}%';

    return Prediction(
      label: label,
      confidenceDecimal: confidenceDecimal,
      confidenceText: confidenceText,
    );
  }
}

class Label {
  final String text;
  final int index;

  Label({required this.text, required this.index});
}