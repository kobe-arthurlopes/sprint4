import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sprint4_app/home/data/models/image_label_result.dart';
import 'package:sprint4_app/home/data/models/label.dart';
import 'package:sprint4_app/home/data/models/prediction.dart';

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