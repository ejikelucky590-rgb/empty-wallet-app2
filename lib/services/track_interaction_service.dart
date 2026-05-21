import 'package:supabase_flutter/supabase_flutter.dart';

class TrackInteractionService {
  final _supabase = Supabase.instance.client;

  // 1. Log a play count when a user listens to a track
  Future<void> logPlay(String trackId) async {
    try {
      final user = _supabase.auth.currentUser;
      await _supabase.from('track_plays').insert({
        'track_id': trackId,
        if (user != null) 'user_id': user.id,
      });
    } catch (e) {
      print('Error logging playback interaction metrics: $e');
    }
  }

  // 2. Like or unlike a track
  Future<bool> toggleLike(String trackId, bool currentlyLiked) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return currentlyLiked;

      if (currentlyLiked) {
        await _supabase
            .from('track_likes')
            .delete()
            .eq('user_id', user.id)
            .eq('track_id', trackId);
        return false;
      } else {
        await _supabase.from('track_likes').insert({
          'user_id': user.id,
          'track_id': trackId,
        });
        return true;
      }
    } catch (e) {
      print('Error updating track preference state: $e');
      return currentlyLiked;
    }
  }

  // 3. Post a comment on a track
  Future<bool> addComment(String trackId, String content) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null || content.trim().isEmpty) return false;

      await _supabase.from('track_comments').insert({
        'user_id': user.id,
        'track_id': trackId,
        'content': content.trim(),
      });
      return true;
    } catch (e) {
      print('Error posting track feedback entry: $e');
      return false;
    }
  }

  // 4. Fetch a track complete with its creator's profile data
  Future<Map<String, dynamic>?> getTrackDetails(String trackId) async {
    try {
      final response = await _supabase
          .from('tracks')
          .select('*, profiles:user_id(username, full_name, avatar_url)')
          .eq('id', trackId)
          .maybeSingle();
      return response;
    } catch (e) {
      print('Error compilation cross-database metadata: $e');
      return null;
    }
  }
}
