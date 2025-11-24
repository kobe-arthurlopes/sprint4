import 'package:flutter/material.dart';
import 'package:sprint4_app/data/data_sources/home_remote_data_source.dart';
import 'package:sprint4_app/data/models/image_label_result.dart';

class HomeRepository extends ChangeNotifier {
  final RemoteDataSource remote;

  HomeRepository({required this.remote});

  Future<List<ImageLabelResult>> fetchData() async {
    return await remote.fetch();
  }
  Future<void> createData(ImageLabelResult imageLabel) async {
    await remote.create();
  }

}