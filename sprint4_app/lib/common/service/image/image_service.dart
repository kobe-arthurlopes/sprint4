import 'package:image_picker/image_picker.dart';
import 'package:sprint4_app/common/service/image/image_service_protocol.dart';

class ImageService implements ImageServiceProtocol {
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
    return await picker.pickImage(source: source);
  }
}
