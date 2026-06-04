import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/music_model.dart';

class MusicRepository {
  MusicRepository._();

  static final instance = MusicRepository._();

  final _client = Supabase.instance.client;

  Future<List<MusicModel>> fetchLatestMusic() async {
    try {
      final data = await _client
          .from('music')
          .select()
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => MusicModel.fromMap(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<MusicModel>> fetchArtistMusic(String ownerId) async {
    try {
      final data = await _client
          .from('music')
          .select()
          .eq('owner_id', ownerId)
          .order('created_at', ascending: false);

      return (data as List)
          .map((e) => MusicModel.fromMap(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> incrementPlay(String musicId) async {
    try {
      await _client.rpc(
        'increment_music_play_count',
        params: {'music_id': musicId},
      );
    } catch (_) {}
  }
}
