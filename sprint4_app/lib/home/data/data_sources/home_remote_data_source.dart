import 'package:sprint4_app/home/data/models/image_label_result.dart';
import 'package:sprint4_app/common/service/supabase_service_protocol.dart';

class HomeRemoteDataSource {
  final SupabaseServiceProtocol supabaseService;

  HomeRemoteDataSource({required this.supabaseService});

  Future<List<ImageLabelResult>> fetch() async {
    return await supabaseService.getImageLabelResults();
  }

  Future<void> createResult(ImageLabelResult result) async {
    final file = result.file;

    if (file == null) return;

    await supabaseService.createImageLabelResult(file);
  }

  Future<void> deleteResult(String id) async {
    await supabaseService.deleteImageLabelResult(id: id);
  }
}