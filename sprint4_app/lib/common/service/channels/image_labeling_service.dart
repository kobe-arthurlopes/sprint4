import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sprint4_app/common/service/channels/method_channel_type.dart';
import 'package:sprint4_app/common/models/image_label_result.dart';
import 'package:sprint4_app/common/models/label.dart';
import 'package:sprint4_app/common/models/prediction.dart';

class ImageLabelingService {
  static Future<ImageLabelResult> getLabeledImage({required String filePath}) async {
    if (filePath.isEmpty) return ImageLabelResult();

    final file = File(filePath);

    final bytes = await file.readAsBytes();
    final list = bytes.buffer.asUint8List();
    final arguments = {'bytes': list};
    final result = await MethodChannelType.imageLabeling.getResult(
      arguments: arguments
    );

    final predictions = (result as List)
        .map(
          (element) => Prediction.fromImageLabelingMap(
            Map<String, dynamic>.from(element),
          ),
        )
        .toList();

    return ImageLabelResult(
      predictions: predictions, 
      filePath: filePath, 
      file: file
    );
  }

  static Future<List<Label>> fetchLabelsFromJson() async {
    try {
      final jsonString = await rootBundle.loadString('lib/common/models/labels.json');
      final data = json.decode(jsonString);
      final maps = (data as List).cast<Map<String, dynamic>>();
      return maps.map((element) => Label.fromMap(element)).toList();
    } catch (error) {
      print('error loading labels.json -> $error');
      return [];
    }
  }

  static Future<dynamic> _getMockedPredictionsResult() async {
    final List<Map<String, dynamic>> arguments = [
      {'index': 360, 'text': 'Dog', 'confidence': 0.9893},
      {'index': 277, 'text': 'Pet', 'confidence': 0.9621},
    ];

    return arguments;
  }
}
