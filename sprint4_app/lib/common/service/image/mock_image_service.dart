import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sprint4_app/common/service/image/image_service_protocol.dart';

class MockImageService implements ImageServiceProtocol {
  @override
  ImagePicker picker = ImagePicker();

  @override
  ImageSource source = ImageSource.camera;

  @override
  void setSource(ImageSource value) {
    source = value;
  }

  @override
  Future<XFile?> pickImage() async {
    final imageName = 'example_img.jpg';
    final byteData = await rootBundle.load('assets/images/$imageName');
    final bytes = byteData.buffer.asUint8List();

    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/$imageName');
    await tempFile.writeAsBytes(bytes, flush: true);

    return XFile(tempFile.path);
  }
}
