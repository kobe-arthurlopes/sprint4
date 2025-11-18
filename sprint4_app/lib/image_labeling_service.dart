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

    final labels = (result as List)
        .map(
          (element) => ImageLabel.fromMap(Map<String, dynamic>.from(element)),
        )
        .toList();

    return ImageLabelResult(labels: labels, file: file);
  }

  static Future<List<ImageLabel>> labelImage(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final list = bytes.buffer.asUint8List();

    final result = await _channel.invokeMethod('labelImage', {'bytes': list});

    final labeledImages = (result as List)
        .map(
          (element) => ImageLabel.fromMap(Map<String, dynamic>.from(element)),
        )
        .toList();

    return labeledImages;
  }
}

class ImageLabelResult {
  List<ImageLabel> labels;
  File? file;

  ImageLabelResult({List<ImageLabel>? labels, this.file})
    : labels = labels ?? [];
}

class ImageLabel {
  final String text;
  final double confidenceDecimal;
  final String confidenceText;
  final int index;

  const ImageLabel({
    required this.text,
    required this.confidenceDecimal,
    required this.confidenceText,
    required this.index,
  });

  factory ImageLabel.fromMap(Map<String, dynamic> map) {
    final text = map['text'];
    final confidenceDecimal = map['confidence'];
    final confidenceText = '${(confidenceDecimal * 100).toStringAsFixed(2)}%';
    final index = map['index'];

    return ImageLabel(
      text: text,
      confidenceDecimal: confidenceDecimal,
      confidenceText: confidenceText,
      index: index,
    );
  }
}
