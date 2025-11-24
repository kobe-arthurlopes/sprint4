import 'package:sprint4_app/common/service/supabase_service_protocol.dart';
import 'package:sprint4_app/data/models/image_label_result.dart';

class RemoteDataSource {
  final SupabaseServiceProtocol supabaseService;

  RemoteDataSource({required this.supabaseService});

  Future<List<ImageLabelResult>> fetch() async {
    return await supabaseService.getImageLabelResults();
  }

  Future<void> create() async {
    await supabaseService.createImageLabelResult();
  }

  Future<void> delete(String id) async {
    await supabaseService.deleteImageLabelResult(id: id);
  }
}