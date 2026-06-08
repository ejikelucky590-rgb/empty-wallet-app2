import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/content_model.dart';

class HubRepository {
  HubRepository._();
  static final instance = HubRepository._();

  final _client = Supabase.instance.client;

  /// Main feed (Spotify-style discovery)
  Future<List<ContentModel>> fetchHubTracks() async {
    try {
      final data = await _client
          .from('content')
          .select('*, profiles(username, avatar_url)')
          .eq('type', 'track')
          .eq('status', 'active')
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => ContentModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Trending (simple version for now)
  Future<List<ContentModel>> fetchTrendingTracks() async {
    try {
      final data = await _client
          .from('content')
          .select('*, profiles(username, avatar_url)')
          .eq('type', 'track')
          .eq('status', 'active')
          .order('views_count', ascending: false)
          .limit(50);

      return (data as List)
          .map((e) => ContentModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Artist-based feed (future personalization)
  Future<List<ContentModel>> fetchByArtist(String userId) async {
    final data = await _client
        .from('content')
        .select('*, profiles(username, avatar_url)')
        .eq('user_id', userId)
        .eq('type', 'track')
        .order('created_at', ascending: false);

    return (data as List)
        .map((e) => ContentModel.fromJson(e))
        .toList();
  }
}
