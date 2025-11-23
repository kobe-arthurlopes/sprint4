import 'package:sprint4_app/common/service/sign_in/sign_in_method.dart';
import 'package:sprint4_app/common/service/supabase_service_protocol.dart';
import 'package:sprint4_app/home/data/models/image_label_result.dart';
import 'package:sprint4_app/home/data/models/label.dart';
import 'package:sprint4_app/home/data/models/prediction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService implements SupabaseServiceProtocol {
  late final SupabaseClient _supabase;
  bool isAuthenticated = false;
  SignInMethod signInMethod = SignInMethod.unknown;

  // String? _email;
  // String? _password;

  SupabaseService() {
    _initialize();
  }

  Future<void> _initialize() async {
    _supabase = Supabase.instance.client;
  }

  @override
  Future<void> authenticate() async {
    try {
      final response = await _getAuthResponse();

      // final response = await _supabase.auth.signInWithPassword(
      //   email: 'mocked.email@gmail.com',
      //   password: '1234',
      // );

      if (response.user != null && response.session != null) {
        isAuthenticated = true;
        print("login succeeded — userId: ${response.user!.id}");
        return;
      }

      isAuthenticated = false;
      print("login failed — userId: ${response.user?.id}");
    } catch (error) {
      print('error authenticating on Supabase -> $error');
    }
  }

  Future<AuthResponse> _getAuthResponse() async {
    final signInService = signInMethod.signInService();
    final rawNonce = _supabase.auth.generateRawNonce();

    final idToken = await signInService.getIdToken(rawNonce: rawNonce);

    if (idToken == null) {
      throw const AuthException(
        'Could not find ID Token from generated credential.',
      );
    }

    return _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }

  @override
  Future<List<Label>> getLabels() async {
    if (!isAuthenticated) return [];

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
    if (!isAuthenticated) return null;

    try {
      final data = await _supabase
          .from('labels')
          .select()
          .eq('id', id)
          .limit(1);

      final item = data.first;
      return Label.fromMap(item);
    } catch (error) {
      print('error getting label with id $id -> $error');
      return null;
    }
  }

  @override
  Future<void> createImageLabelResult({String? filePath}) async {
    if (!isAuthenticated) return;

    final user = _supabase.auth.currentUser;

    if (user == null) return;

    try {
      final data = await _supabase
          .from('image_label_results')
          .insert({'user_id': user.id, 'file_path': filePath})
          .select()
          .limit(1);

      final item = data.first;
      final result = ImageLabelResult.fromMap(item);

      print('created image label result with id ${result.id}');
    } catch (error) {
      print('error creatings image label result -> $error');
    }
  }

  @override
  Future<List<ImageLabelResult>> getImageLabelResults() async {
    if (!isAuthenticated) return [];

    try {
      final data = await _supabase.from('image_label_results').select();

      final imageLabelResultFutures = data.map((element) async {
        var result = ImageLabelResult.fromMap(element);
        final predictions = await getPredictions(resultId: result.id);
        result.predictions = predictions;
        return result;
      }).toList();

      return await Future.wait(imageLabelResultFutures);
    } catch (error) {
      print('error getting image label results -> $error');
      return [];
    }
  }

  @override
  Future<void> updateImageLabelResult({
    required String id,
    String? filePath,
  }) async {
    if (!isAuthenticated) return;

    try {
      await _supabase
          .from('image_label_results')
          .update({'file_path': filePath})
          .eq('id', id);

      print('updated image label result with id $id');
    } catch (error) {
      print('error upating image label result with id $id -> $error');
    }
  }

  @override
  Future<void> deleteImageLabelResult({required String id}) async {
    if (!isAuthenticated) return;

    try {
      await _supabase.from('image_label_results').delete().eq('id', id);

      print('deleted image label result with id $id');
    } catch (error) {
      print('error deleting image label result with id $id -> $error');
    }
  }

  @override
  Future<void> createPrediction({
    required String resultId,
    required int labelId,
    required double confidence,
  }) async {
    if (!isAuthenticated) return;

    try {
      final data = await _supabase
          .from('predictions')
          .insert({
            'result_id': resultId,
            'label_id': labelId,
            'confidence': confidence,
          })
          .select()
          .limit(1);

      final item = data.first;
      final prediction = Prediction.fromDBMap(item);

      print('created prediction with id ${prediction.id}');
    } catch (error) {
      print('error creating prediction -> error');
    }
  }

  @override
  Future<List<Prediction>> getPredictions({String? resultId}) async {
    if (!isAuthenticated) return [];

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
    if (!isAuthenticated) return;

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
    if (!isAuthenticated) return;

    try {
      await _supabase.from('predictions').delete().eq('id', id);

      print('deleted prediction with id $id');
    } catch (error) {
      print('error updating prediction with id $id -> $error');
    }
  }
}
