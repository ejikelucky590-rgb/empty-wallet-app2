import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class SocialController {
  final _client = Supabase.instance.client;

  Future<bool> toggleFollow(String targetUserId) async {
    final myId = _client.auth.currentUser?.id;
    if (myId == null || myId == targetUserId) return false;

    try {
      // Check if already following
      final existing = await _client
          .from('connections')
          .select()
          .eq('follower_id', myId)
          .eq('following_id', targetUserId)
          .maybeSingle();

      if (existing != null) {
        // Unfollow
        await _client.from('connections')
            .delete()
            .eq('follower_id', myId)
            .eq('following_id', targetUserId);
        return false; // Now not following
      } else {
        // Follow
        await _client.from('connections').insert({
          'follower_id': myId,
          'following_id': targetUserId,
        });
        return true; // Now following
      }
    } catch (e) {
      debugPrint('🚨 Follow error: $e');
      return false;
    }
  }
}
