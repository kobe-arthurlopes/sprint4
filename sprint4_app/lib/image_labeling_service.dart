import 'dart:convert';
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
          (element) => Prediction.fromImageLabelingMap(Map<String, dynamic>.from(element)),
        )
        .toList();

    return ImageLabelResult(predictions: predictions, file: file);
  }

  static Future<List<Label>> fetchLabelsFromJson() async {
    try {
      final jsonString = await rootBundle.loadString('lib/labels.json');
      final data = json.decode(jsonString);
      final maps = (data as List).cast<Map<String, dynamic>>();
      return maps.map((element) => Label.fromMap(element)).toList();
    } catch (error) {
      print('error loading labels.json -> $error');
      return [];
    }
  }
}

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

class Prediction {
  final String id;
  final Label label;
  final double confidenceDecimal;
  final String confidenceText;

  Prediction({
    String? id,
    Label? label,
    required this.confidenceDecimal,
    required this.confidenceText,
  }) : id = id ?? '', label = label ?? Label();

  factory Prediction.fromImageLabelingMap(Map<String, dynamic> map) {
    final labelIndex = map['index'];
    final labelText = map['text'];
    final Label label = Label(id: labelIndex, text: labelText);
    final confidenceDecimal = map['confidence'];
    final confidenceText = '${(confidenceDecimal * 100).toStringAsFixed(2)}%';

    return Prediction(
      label: label,
      confidenceDecimal: confidenceDecimal,
      confidenceText: confidenceText,
    );
  }

  factory Prediction.fromDBMap(Map<String, dynamic> map) {
    final id = map['id'];
    final label = map['label'] ?? Label();
    final confidenceDecimal = map['confidence'];
    final confidenceText = '${(confidenceDecimal * 100).toStringAsFixed(2)}%';

    return Prediction(
      id: id,
      label: label, 
      confidenceDecimal: confidenceDecimal, 
      confidenceText: confidenceText
    );
  }
}

class Label {
  final int id;
  final String text;

  Label({int? id, String? text})
    : id = id ?? 0, text = text ?? '';

  factory Label.fromMap(Map<String, dynamic> map) {
    return Label(
      id: map['id'], 
      text: map['text']
    );
  }
}
