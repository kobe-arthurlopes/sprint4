import 'package:flutter/services.dart';

class ImageLabelingChannel {
  static const _channel = MethodChannel('com.sprint4/image_labeling');

  static Future<List<LabeledImage>> labelImage(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final list = bytes.buffer.asUint8List();

    final result = await _channel.invokeMethod('labelImage', {
      'bytes': list
    });

    final labeledImages = (result as List)
      .map((element) => LabeledImage.fromMap(Map<String, dynamic>.from(element)))
      .toList();

    return labeledImages;
  }
}

class LabeledImage {
  final String text;
  final String confidence;
  final int index;

  const LabeledImage({required this.text, required this.confidence, required this.index});

  factory LabeledImage.fromMap(Map<String, dynamic> map) {
    final text = map['text'];
    final confidence = '${(map['confidence'] * 100).toStringAsFixed(2)}%';
    final index = map['index'];

    return LabeledImage(
      text: text, 
      confidence: confidence, 
      index: index
    );
  }
}
