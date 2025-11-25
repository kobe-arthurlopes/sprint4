import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sprint4_app/common/service/authentication/authentication_service_protocol.dart';
import 'package:sprint4_app/common/service/supabase/supabase_service_protocol.dart';
import 'package:sprint4_app/common/models/image_label_result.dart';
import 'package:sprint4_app/common/models/label.dart';
import 'package:sprint4_app/common/models/prediction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseService implements SupabaseServiceProtocol {
  late final SupabaseClient _supabase;

  @override
  late final AuthenticationServiceProtocol authentication;

  SupabaseService({required this.authentication}) {
    _initialize();
  }

  Future<void> _initialize() async {
    _supabase = Supabase.instance.client;
    authentication.setClient(_supabase.auth);
  }

  // LABELS
  @override
  Future<List<Label>> getLabels() async {
    if (!authentication.isAuthenticated) return [];

    try {
      final data = await _supabase.from('labels').select();

      return data.map((element) => Label.fromMap(element)).toList();
    } catch (error) {
      print('error getting labels -> $error');
      return [];
    }
  }

  @override
  Future<Label?> getLabel({required int id}) async {
    if (!authentication.isAuthenticated) return null;

    try {
      final data = await _supabase
          .from('labels')
          .select()
          .eq('id', id)
          .single();

      return Label.fromMap(data);
    } catch (error) {
      print('error getting label with id $id -> $error');
      return null;
    }
  }

  // IMAGE LABEL RESULT
  @override
  Future<void> createImageLabelResult({
    required ImageLabelResult result,
  }) async {
    if (!authentication.isAuthenticated) return;

    final user = _supabase.auth.currentUser;

    if (user == null) return;

    final file = result.file;

    if (file == null) return;

    final newFilePath = await _uploadImage(file: file, uid: user.id);

    try {
      final data = await _supabase
          .from('image_label_results')
          .insert({'user_id': user.id, 'file_path': newFilePath})
          .select()
          .single();

      final fetchedResult = ImageLabelResult.fromMap(data);

      await Future.wait(
        result.predictions.map(
          (prediction) => createPrediction(
            resultId: fetchedResult.id,
            labelId: prediction.label.id,
            confidence: prediction.confidenceDecimal,
          ),
        ),
      );

      print('created image label result with id ${fetchedResult.id}');
    } catch (error) {
      print('error creatings image label result -> $error');
    }
  }

  Future<String> _uploadImage({required File file, required String uid}) async {
    final fileName = const Uuid().v4();
    final filePath = '$uid/$fileName.png';
    final storage = _supabase.storage.from('images');

    await storage.upload(
      filePath,
      file,
      fileOptions: const FileOptions(upsert: false),
    );

    return filePath;
  }

  Future<ImageLabelResult> _getCompleteImageLabelResult({
    required ImageLabelResult emptyResult,
    required StorageFileApi storage,
  }) async {
    try {
      final bytes = await storage.download(emptyResult.filePath);
      final temp = File(
        '${(await getTemporaryDirectory()).path}/${emptyResult.id}',
      );
      await temp.writeAsBytes(bytes);
      emptyResult.file = temp;
    } catch (error) {
      print("error downloading image ${emptyResult.id}: $error");
      emptyResult.file = null;
    }

    final predictions = await getPredictions(resultId: emptyResult.id);
    emptyResult.predictions = predictions;

    return emptyResult;
  }

  Future<ImageLabelResult?> _getImageLabelResult({
    required String id,
    required StorageFileApi storage,
  }) async {
    if (!authentication.isAuthenticated) return null;

    try {
      final data = await _supabase
          .from('image_label_results')
          .select()
          .eq('id', id)
          .single();

      final emptyResult = ImageLabelResult.fromMap(data);

      return await _getCompleteImageLabelResult(
        emptyResult: emptyResult,
        storage: storage,
      );
    } catch (error) {
      print('error getting image label result with id $id -> $error');
      return null;
    }
  }

  @override
  Future<List<ImageLabelResult>> getImageLabelResults() async {
    if (!authentication.isAuthenticated) return [];

    final storage = _supabase.storage.from('images');

    try {
      final data = await _supabase.from('image_label_results').select();

      final nullableResults = await Future.wait(
        data.map((item) async {
          final id = item['id'] as String;
          return await _getImageLabelResult(id: id, storage: storage);
        }).toList(),
      );

      return nullableResults.whereType<ImageLabelResult>().toList();
    } catch (error) {
      print('error getting image label results -> $error');
      return [];
    }
  }

  @override
  Future<void> updateImageLabelResult({
    required String id,
    File? newFile,
    List<Prediction>? newPredictions,
  }) async {
    if (!authentication.isAuthenticated) return;

    final user = _supabase.auth.currentUser;

    if (user == null) return;

    try {
      final storage = _supabase.storage.from('images');

      final currentResult = await _getImageLabelResult(
        id: id,
        storage: storage,
      );

      if (currentResult == null) return;

      String? newFilePath;

      if (newFile != null) {
        newFilePath = await _uploadImage(file: newFile, uid: user.id);
      }

      if (newFilePath != null) {
        await _supabase
            .from('image_label_results')
            .update({'file_path': newFilePath})
            .eq('id', id);

        final currentFilePath = currentResult.filePath;
        await _deleteImage(filePath: currentFilePath);

        print('updated file path for image label result with id $id');
      } else {
        print(
          'could not update file path for image result with id $id -> new file path is null',
        );
      }

      if (newPredictions != null) {
        final currentPredictions = currentResult.predictions;

        await _updatePredictions(
          resultId: id,
          oldPredictions: currentPredictions,
          newPredictions: newPredictions,
        );
      }

      print('updated image label result with id $id');
    } catch (error) {
      print('error updating image label result with id $id -> $error');
    }
  }

  @override
  Future<void> deleteImageLabelResult({required String id}) async {
    if (!authentication.isAuthenticated) return;

    try {
      final data = await _supabase
          .from('image_label_results')
          .delete()
          .eq('id', id)
          .select()
          .single();

      final result = ImageLabelResult.fromMap(data);
      await _deleteImage(filePath: result.filePath);

      print('deleted image label result with id $id');
    } catch (error) {
      print('error deleting image label result with id $id -> $error');
    }
  }

  Future<void> _deleteImage({required String filePath}) async {
    final storage = _supabase.storage.from('images');
    await storage.remove([filePath]);
  }

  // PREDICTION
  @override
  Future<void> createPrediction({
    required String resultId,
    required int labelId,
    required double confidence,
  }) async {
    if (!authentication.isAuthenticated) return;

    try {
      final data = await _supabase
          .from('predictions')
          .insert({
            'result_id': resultId,
            'label_id': labelId,
            'confidence': confidence,
          })
          .select()
          .single();

      final prediction = Prediction.fromDBMap(data);

      print('created prediction with id ${prediction.id}');
    } catch (error) {
      print('error creating prediction -> error');
    }
  }

  @override
  Future<List<Prediction>> getPredictions({String? resultId}) async {
    if (!authentication.isAuthenticated) return [];

    try {
      final List<Map<String, dynamic>> data;

      if (resultId != null) {
        data = await _supabase
            .from('predictions')
            .select()
            .eq('result_id', resultId);
      } else {
        data = await _supabase.from('predictions').select();
      }

      final predictionFutures = data.map((element) async {
        final labelId = element['label_id'];
        final label = await getLabel(id: labelId);
        element['label'] = label;
        return Prediction.fromDBMap(element);
      }).toList();

      return await Future.wait(predictionFutures);
    } catch (error) {
      print('error getting predictions -> $error');
      return [];
    }
  }

  @override
  Future<void> updatePrediction({
    required String id,
    String? resultId,
    int? labelId,
    double? confidence,
  }) async {
    if (!authentication.isAuthenticated) return;

    if (resultId == null && labelId == null && confidence == null) {
      print('no proprerties passed to update prediction with id $id');
      return;
    }

    Map<String, dynamic> insertionMap = {};

    if (resultId != null) insertionMap['result_id'] = resultId;
    if (labelId != null) insertionMap['label_id'] = labelId;
    if (confidence != null) insertionMap['confidence'] = confidence;

    try {
      await _supabase.from('predictions').update(insertionMap).eq('id', id);

      print('updated prediction with id $id');
    } catch (error) {
      print('error updating prediction with id $id -> $error');
    }
  }

  @override
  Future<void> deletePrediction({required String id}) async {
    if (!authentication.isAuthenticated) return;

    try {
      await _supabase.from('predictions').delete().eq('id', id);

      print('deleted prediction with id $id');
    } catch (error) {
      print('error updating prediction with id $id -> $error');
    }
  }

  void _sortPredictions(List<Prediction> predictions) {
    predictions.sort((a, b) => a.label.id.compareTo(b.label.id));
  }

  Future<void> _updatePredictions({
    required String resultId,
    required List<Prediction> oldPredictions,
    required List<Prediction> newPredictions,
  }) async {
    if (newPredictions.isNotEmpty &&
        newPredictions.length == oldPredictions.length) {
      _sortPredictions(oldPredictions);
      _sortPredictions(newPredictions);

      await Future.wait(
        List.generate(newPredictions.length, (index) {
          final oldPrediction = oldPredictions[index];
          final newPrediction = newPredictions[index];

          return updatePrediction(
            id: oldPrediction.id,
            resultId: resultId,
            labelId: oldPrediction.label.id,
            confidence: newPrediction.confidenceDecimal,
          );
        }),
      );
    }
  }
}