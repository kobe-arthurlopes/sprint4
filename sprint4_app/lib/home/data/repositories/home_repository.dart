import 'package:sprint4_app/home/data/data_sources/home_remote_data_source.dart';
import 'package:sprint4_app/common/models/image_label_result.dart';
import 'package:sprint4_app/home/data/models/home_data.dart';

class HomeRepository {
  final HomeRemoteDataSource remote;

  HomeRepository({required this.remote});

  Future<HomeData> fetchData() async {
    return await remote.fetch();
  }

  Future<void> createResult(ImageLabelResult result) async {
    await remote.createResult(result);
  }
}
