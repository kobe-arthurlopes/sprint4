import 'package:flutter/services.dart';

class ImageLabelingChannel {
  static const _channel = MethodChannel('com.sprint4/image_labeling');

  // static Future<List<String>> labelImage(String imagePath) async {
  //   final List<dynamic> labels = await _channel.invokeMethod('labelImage', {
  //     'path': imagePath,
  //   });

  //   return labels.cast<String>();
  // }

  static Future<List<String>> labelImage(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final list = bytes.buffer.asUint8List();

    final result = await _channel.invokeMethod('labelImage', {
      'bytes': list
    });

    return List<String>.from(result);
  }
}
