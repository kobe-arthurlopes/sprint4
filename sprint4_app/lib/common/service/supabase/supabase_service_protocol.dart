import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sprint4_app/common/models/image_label_result.dart';
import 'package:sprint4_app/common/models/label.dart';
import 'package:sprint4_app/common/models/prediction.dart';
import 'package:sprint4_app/common/service/authentication/authentication_service_protocol.dart';

abstract class SupabaseServiceProtocol implements ChangeNotifier {
  AuthenticationServiceProtocol get authentication;

  Future<List<Label>> getLabels();
  Future<Label?> getLabel({required int id});
  Future<void> createImageLabelResult({required ImageLabelResult result});
  Future<List<ImageLabelResult>> getImageLabelResults();

  Future<void> updateImageLabelResult({
    required String id, 
    File? newFile,
    List<Prediction>? newPredictions,
  });

  Future<void> deleteImageLabelResult({required String id});

  Future<void> createPrediction({
    required String resultId,
    required int labelId,
    required double confidence,
  });

  Future<List<Prediction>> getPredictions({String? resultId});

  Future<void> updatePrediction({
    required String id,
    String? resultId,
    int? labelId,
    double? confidence,
  });

  Future<void> deletePrediction({required String id});
}
