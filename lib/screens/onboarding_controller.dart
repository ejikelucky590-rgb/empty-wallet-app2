import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingController {
  final _supabase = Supabase.instance.client;
  Timer? usernameDebounce;

  final List<String> _reservedUsernames = [
    'admin', 'support', 'official', 'system', 'null', 'root', 'moderator'
  ];

  void dispose() {
    usernameDebounce?.cancel();
  }

  // Handles async username testing loops against the table index
  Future<Map<String, dynamic>> checkUsernameAvailability(String value) async {
    final username = value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');

    if (username.length < 3) {
      return {'available': false, 'error': 'Username must be at least 3 characters'};
    }
    if (_reservedUsernames.contains(username)) {
      return {'available': false, 'error': 'This username is reserved'};
    }

    try {
      final existing = await _supabase
          .from('profiles')
          .select('id')
          .eq('username', username)
          .maybeSingle();

      return {
        'available': existing == null,
        'error': existing == null ? null : 'Username already taken'
      };
    } catch (_) {
      return {'available': false, 'error': 'Unable to check username'};
    }
  }

  // Bundles profile payload records to backend profile rows
  Future<void> saveProfile({
    required String stageName,
    required String firstName,
    required String lastName,
    required String countryCode,
    required String state,
    required String gender,
    required DateTime birthDate,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('No active session');

    final username = stageName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
    final fullName = '$firstName $lastName'.trim();

    // Secondary runtime collision defense check
    final existing = await _supabase
        .from('profiles')
        .select('id')
        .eq('username', username)
        .maybeSingle();

    if (existing != null) {
      throw Exception('Username already taken');
    }

    await _supabase.from('profiles').update({
      'username': username,
      'stage_name': stageName,
      'full_name': fullName,
      'country_code': countryCode,
      'state_code': state,
      'gender': gender,
      'date_of_birth': birthDate.toIso8601String().split('T')[0],
      'is_onboarded': true,
      'onboarding_completed_at': DateTime.now().toUtc().toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', user.id);
  }
}
