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
    } catch (e) {
      debugPrint('🚨 Cache read failure: $e');
      return [];
    }
  }

  Future<void> save(List<Map<String, dynamic>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(data));
    } catch (e) {
      debugPrint('🚨 Cache write failure: $e');
    }
  }
}

class Backoff {
  int attempt = 0;

  Duration nextDelay() {
    attempt++;
    final seconds = (2 << attempt).clamp(2, 60);
    return Duration(seconds: seconds);
  }

  void reset() => attempt = 0;
}

class ProfileState {
  final ProfileModel? profile;
  final bool loading;
  final int pending;
  final double completion;
  final NetworkState network;

  ProfileState({
    required this.profile,
    required this.loading,
    required this.pending,
    required this.completion,
    required this.network,
  });

  ProfileState copyWith({
    ProfileModel? profile,
    bool? loading,
    int? pending,
    double? completion,
    NetworkState? network,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      loading: loading ?? this.loading,
      pending: pending ?? this.pending,
      completion: completion ?? this.completion,
      network: network ?? this.network,
    );
  }
}

class ProfileController {
  ProfileController._();
  static final instance = ProfileController._();

  final _client = Supabase.instance.client;
  final PersistentQueue _storage = PersistentQueue();
  final Backoff _backoff = Backoff();

  final _stream = StreamController<ProfileState>.broadcast();
  Stream<ProfileState> get stream => _stream.stream;

  ProfileState _state = ProfileState(
    profile: null,
    loading: false,
    pending: 0,
    completion: 0,
    network: NetworkState.online,
  );

  List<Map<String, dynamic>> _queue = [];
  Timer? _timer;
  bool _isSyncing = false;

  ProfileState get state => _state;

  void _emit() {
    _stream.add(_state.copyWith(pending: _queue.length));
  }

  double _calc(ProfileModel? p) {
    if (p == null) return 0;
    int score = 0;

    if (p.stageName.trim().isNotEmpty && p.stageName != 'New Creator') score++;
    if (p.bio.trim().isNotEmpty && p.bio != 'Afrobeat artist • Producer • Creative storyteller') score++;
    if (p.avatarUrl?.isNotEmpty == true) score++;
    if (p.username.trim().isNotEmpty) score++;

    return score / 4;
  }

  Future<void> init() async {
    _queue = await _storage.load();
    await syncProfile();
    _startSync();
  }

  Future<void> syncProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    _state = _state.copyWith(loading: true);
    _emit();

    try {
      final data = await _client.from('profiles').select().eq('id', user.id).maybeSingle();
      if (data != null) {
        _state = _state.copyWith(
          profile: ProfileModel.fromMap(data, user.email?.split('@')[0] ?? "user"),
        );
        _state = _state.copyWith(completion: _calc(_state.profile));
      }
    } catch (e) {
      debugPrint('⚠️ Network loading background delay: $e');
    } finally {
      _state = _state.copyWith(loading: false);
      _emit();
    }
  }

  void _optimistic(Map<String, dynamic> patch) {
    final p = _state.profile;
    if (p == null) return;

    final updated = p.copyWith(
      stageName: patch["stage_name"] ?? p.stageName,
      bio: patch["bio"] ?? p.bio,
      avatarUrl: patch["avatar_url"] ?? p.avatarUrl,
    );

    _state = _state.copyWith(
      profile: updated,
      completion: _calc(updated),
    );
    _emit();
  }

  Future<void> save({
    required String stageName,
    required String bio,
    String? avatarUrl,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final payload = {
      "stage_name": stageName,
      "bio": bio,
      "avatar_url": avatarUrl ?? _state.profile?.avatarUrl,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };

    _optimistic(payload);
    _queue.add(payload);
    await _storage.save(_queue);
    _sync();
  }

  Future<bool> handleAvatarUpload(File file) async {
    _state = _state.copyWith(loading: true);
    _emit();

    final publicUrl = await uploadImage(file);
    if (publicUrl != null) {
      if (_state.profile != null) {
        await save(
          stageName: _state.profile!.stageName,
          bio: _state.profile!.bio,
          avatarUrl: publicUrl,
        );
      }
      return true;
    }
    
    _state = _state.copyWith(loading: false);
    _emit();
    return false;
  }

  Future<String?> uploadImage(File file) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;
      final path = "avatars/${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      await _client.storage.from('avatars').upload(path, file);
      return _client.clientUrl + '/storage/v1/object/public/avatars/' + path;
    } catch (e) {
      debugPrint('🚨 Upload error: $e');
      return null;
    }
  }

  Future<void> _sync() async {
    if (_isSyncing || _queue.isEmpty) return;
    final user = _client.auth.currentUser;
    if (user == null) return;

    _isSyncing = true;
    final item = _queue.first;

    try {
      await _client.from('profiles').update({
        "stage_name": item["stage_name"],
        "bio": item["bio"],
        if (item["avatar_url"] != null) "avatar_url": item["avatar_url"],
        "updated_at": DateTime.now().toIso8601String(),
      }).eq('id', user.id);

      _queue.removeAt(0);
      await _storage.save(_queue);
      _backoff.reset();
      
      _isSyncing = false;
      _emit();

      if (_queue.isNotEmpty) {
        await _sync();
      }
    } catch (e) {
      _isSyncing = false;
      _timer?.cancel();
      _timer = Timer(_backoff.nextDelay(), _sync);
    }
  }

  void _startSync() {
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (_queue.isNotEmpty && !_isSyncing) _sync();
    });
  }

  void setNetwork(NetworkState state) {
    _state = _state.copyWith(network: state);
    if (state == NetworkState.online) _sync();
    _emit();
  }

  void dispose() {
    _timer?.cancel();
    _stream.close();
  }
}
