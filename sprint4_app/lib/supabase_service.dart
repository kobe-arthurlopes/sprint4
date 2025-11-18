import 'package:sprint4_app/image_labeling_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final instance = SupabaseService();
  final _supabase = Supabase.instance.client;
  bool _isAuthenticated = false;

  Future<void> authenticate() async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: 'mocked.email@gmail.com',
        password: '1234'
      );

      if (response.user != null && response.session != null) {
        _isAuthenticated = true;
        print("login succeeded — userId: ${response.user!.id}");
        return;
      }

      _isAuthenticated = false;
      print("login failed — userId: ${response.user?.id}");
    } catch (error) {
      print('error authenticating on Supabase -> $error');
    }
  }

  Future<List<Label>> getLabels() async {
    if (!_isAuthenticated) return [];

    try {
      final data = await _supabase
        .from('labels')
        .select();

      return data.map((element) => Label.fromMap(element)).toList();
    } catch (error) {
      print('error getting labels -> $error');
      return [];
    }
  }

  Future<void> createImageLabelResult() async {
    if (!_isAuthenticated) return;

    final user = _supabase.auth.currentUser;

    if (user == null) return;

    try {
      final data = await _supabase
        .from('image_label_results')
        .insert({'user_id': user.id, 'file_path': null})
        .select()
        .limit(1);

      final item = data.first;
      final result = ImageLabelResult.fromMap(item);

      print('created image label result with id ${result.id}');
    } catch (error) {
      print('error creatings image label result -> $error');
    }
  }

  Future<List<ImageLabelResult>> getImageLabelResults() async {
    if (!_isAuthenticated) return [];

    try {
      final data = await _supabase
        .from('image_label_results')
        .select();

      return data.map((element) => ImageLabelResult.fromMap(element)).toList();
    } catch (error) {
      print('error getting image label results -> $error');
      return [];
    }
  }

  Future<void> updateImageLabelResult(int id, String newFilePath) async {
    if (!_isAuthenticated) return;

    try {
      final data = await _supabase
        .from('image_label_results')
        .update({'file_path': newFilePath})
        .eq('id', id)
        .select()
        .limit(1);

      final item = data.first;
      final result = ImageLabelResult.fromMap(item);

      print('updated image label result with id ${result.id}');
    } catch (error) {
      print('error upating image label result -> $error');
    }
  }

  Future<void> deleteImageLabelResult(int id) async {
    if (!_isAuthenticated) return;

    try {
      final data = await _supabase
        .from('image_label_results')
        .delete()
        .eq('id', id)
        .select()
        .limit(1);

      final item = data.first;
      final result = ImageLabelResult.fromMap(item);

      print('deleted image label result with id ${result.id}');
    } catch (error) {
      print('error deleting image label result -> $error');
    }
  }
}