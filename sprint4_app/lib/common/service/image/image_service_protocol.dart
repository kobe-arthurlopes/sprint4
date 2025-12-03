import 'package:image_picker/image_picker.dart';

abstract class ImageServiceProtocol {
  ImagePicker get picker;
  ImageSource get source;

  void setSource(ImageSource value);

  Future<XFile?> pickImage();
}