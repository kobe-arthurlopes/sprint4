import 'package:sprint4_app/common/models/image_label_result.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';
import 'package:sprint4_app/home/data/models/home_data.dart';

class HomeRemoteDataSource {
  final SupabaseServiceProtocol supabaseService;

  HomeRemoteDataSource({required this.supabaseService});

  Future<HomeData> fetch() async {
    final results = await supabaseService.getImageLabelResults();
    return HomeData(results: results);
  }

  Future<void> createResult(ImageLabelResult result) async {
    await supabaseService.createImageLabelResult(result: result);
  }

  Future<void> deleteResult(String id) async {
    await supabaseService.deleteImageLabelResult(id: id);
  }
}
