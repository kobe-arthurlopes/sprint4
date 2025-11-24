import 'package:flutter/material.dart';
import 'package:sprint4_app/data/data_sources/home_remote_data_source.dart';
import 'package:sprint4_app/data/models/image_label_result.dart';

class ListRepository extends ChangeNotifier {
  final RemoteDataSource remote;

  ListRepository({required this.remote});

  Future<List<ImageLabelResult>> fetchData() async {
    return await remote.fetch();
  }
  Future<void> deleteData(String id) async {
    await remote.delete(id);
  }

}