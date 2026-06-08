import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/content_model.dart';

class ContentRepository {
  ContentRepository._();
  static final instance = ContentRepository._();

  final _client = Supabase.instance.client;

  Future<List<ContentModel>> fetchContentByType(String type, {int from = 0, int to = 49}) async {
    try {
      final PostgrestFilterBuilder query = _client
          .from('content')
          .select('*, profiles(username, avatar_url)')
          .eq('type', type)
          .eq('status', 'active');

      final data = await query
          .order('created_at', ascending: false)
          .range(from, to);

      return (data as List).map((e) => ContentModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('fetchContentByType error: $e');
      return [];
    }
  }

  Future<void> incrementView(String contentId) async {
    try {
      await _client.rpc('increment_content_views', params: {'row_id': contentId});
    } catch (e) {
      debugPrint('incrementView error: $e');
    }
  }
}
