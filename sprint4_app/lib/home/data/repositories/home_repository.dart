import 'package:sprint4_app/home/data/data_sources/home_remote_data_source.dart';
import 'package:sprint4_app/home/data/models/image_label_result.dart';

class HomeRepository {
  final HomeRemoteDataSource remote;

  HomeRepository({required this.remote});

  Future<List<ImageLabelResult>> fetchData() async {
    return await remote.fetch();
  }
}