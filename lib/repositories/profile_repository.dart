import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> isUsernameAvailable(String username) async {
    final existing = await _supabase
        .from('profiles')
        .select('id')
        .eq('username', username)
        .maybeSingle();

    return existing == null;
  }

  Future<void> updateProfile({
    required String userId,
    required String username,
    required String stageName,
    required String fullName,
    required String countryCode,
    required String state,
    required String gender,
    required DateTime birthDate,
    String? avatarUrl,
  }) async {
    await _supabase.from('profiles').update({
      'username': username,
      'stage_name': stageName,
      'full_name': fullName,
      'country_code': countryCode,
      'state_code': state,
      'gender': gender,
      'date_of_birth': birthDate.toIso8601String().split('T')[0],
      'avatar_url': avatarUrl,
      'is_onboarded': true,
      'onboarding_completed_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', userId);
  }
}
