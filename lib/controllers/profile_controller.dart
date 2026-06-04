import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
      if (raw == null) return [];
      return List<Map<String, dynamic>>.from(jsonDecode(raw));
    } catch (e) { return []; }
  }
  
  Future<void> save({required String stageName, required Map<String, dynamic> data}) async {
    // Logic here
    notifyListeners();
  }
 catch (e) {}
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
  final PersistentQueue _storage = PersistentQueue();
  final _stream = StreamController<ProfileState>.broadcast();
  Stream<ProfileState> get stream => _stream.stream;
  ProfileState _state = ProfileState(profile: null, loading: false, pending: 0, completion: 0, network: NetworkState.online);
  List<Map<String, dynamic>> _queue = [];
  bool _isSyncing = false;

  ProfileState get state => _state;
  void _emit() => _stream.add(_state.copyWith(pending: _queue.length));

  List<String> getMissingFields(ProfileModel? p) {
    if (p == null) return [];
    final missing = <String>[];
    if (p.avatarUrl == null || p.avatarUrl!.isEmpty) missing.add('Photo');
    if (p.stageName.isEmpty || p.stageName == 'New Creator') missing.add('Name');
    if (p.bio.isEmpty || p.bio.contains('artist • Producer')) missing.add('Bio');
    return missing;
  }

  Future<void> dismissCompletionCard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dismissed_card_at', DateTime.now().toIso8601String());
    _emit();
  }

  Future<bool> shouldShowCompletionCard() async {
    final prefs = await SharedPreferences.getInstance();
    final dismissedAt = prefs.getString('dismissed_card_at');
    if (dismissedAt == null) return true;
    return DateTime.now().difference(DateTime.parse(dismissedAt)).inHours >= 24;
  }

  // Note: Add your other sync/init/save methods here exactly as they were in your functional version

  // Sync pending local changes to remote
  Future<void> syncProfile() async {
    // Implement your sync logic here
    notifyListeners();
  }

  // Handle avatar upload
  Future<bool> handleAvatarUpload(dynamic file) async {
    // Implement your file upload logic here
    return true;
  }

  // Save profile updates
  
  Future<void> save({required String stageName, required Map<String, dynamic> data}) async {
    // Logic here
    notifyListeners();
  }

}