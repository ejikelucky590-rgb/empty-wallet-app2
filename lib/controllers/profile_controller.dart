import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

enum NetworkState { online, offline }

class PersistentQueue {
  static const _key = "profile_sync_queue";
  
  Future<List<Map<String, dynamic>>> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      return raw == null ? [] : List<Map<String, dynamic>>.from(jsonDecode(raw));
    } catch (e) { return []; }
  }
}

class ProfileState {
  final ProfileModel? profile;
  final bool loading;
  final int pending;
  final double completion;
  final NetworkState network;
  
  ProfileState({required this.profile, required this.loading, required this.pending, required this.completion, required this.network});
  
  ProfileState copyWith({ProfileModel? profile, bool? loading, int? pending, double? completion, NetworkState? network}) {
    return ProfileState(
      profile: profile ?? this.profile,
      loading: loading ?? this.loading,
      pending: pending ?? this.pending,
      completion: completion ?? this.completion,
      network: network ?? this.network,
    );
  }
}

class ProfileController extends ChangeNotifier {
  ProfileController._();
  static final instance = ProfileController._();
  
  final _client = Supabase.instance.client;
  final _stream = StreamController<ProfileState>.broadcast();
  
  ProfileState _state = ProfileState(profile: null, loading: false, pending: 0, completion: 0, network: NetworkState.online);
  
  Stream<ProfileState> get stream => _stream.stream;
  ProfileState get state => _state;

  Future<void> save({required String stageName, required String bio, Map<String, dynamic>? data}) async {
    try {
      // Implement your Supabase update logic here
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving: $e');
    }
  }

  Future<void> syncProfile() async {
    notifyListeners();
  }

  Future<bool> handleAvatarUpload(dynamic file) async {
    return true;
  }
}
