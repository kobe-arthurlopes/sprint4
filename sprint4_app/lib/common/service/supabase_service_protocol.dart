import 'package:sprint4_app/home/data/models/image_label_result.dart';
import 'package:sprint4_app/home/data/models/label.dart';
import 'package:sprint4_app/home/data/models/prediction.dart';

abstract class SupabaseServiceProtocol {
  Future<void> authenticate();
  Future<List<Label>> getLabels();
  Future<Label?> getLabel({required int id});
  Future<void> createImageLabelResult({String? filePath});
  Future<List<ImageLabelResult>> getImageLabelResults();
  Future<void> updateImageLabelResult({required String id, String? filePath});
  Future<void> deleteImageLabelResult({required String id});

  Future<void> createPrediction({
    required String resultId, 
    required int labelId, 
    required double confidence
  });

  Future<List<Prediction>> getPredictions({String? resultId});

  Future<void> updatePrediction({
    required String id,
    String? resultId, 
    int? labelId, 
    double? confidence
  });

  Future<void> deletePrediction({required String id});
}