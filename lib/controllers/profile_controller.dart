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
      final decoded = jsonDecode(raw);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (e) {
      debugPrint('🚨 PersistentQueue Load Error: $e');
      return [];
    }
  }

  Future<void> save(List<Map<String, dynamic>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, jsonEncode(data));
    } catch (e) {
      debugPrint('🚨 PersistentQueue Save Error: $e');
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

class ProfileController extends ChangeNotifier {
  static final ProfileController instance = ProfileController._internal();
  ProfileController._internal();

  final _client = Supabase.instance.client;
  final PersistentQueue _storage = PersistentQueue();
  final Backoff _backoff = Backoff();
  
  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  NetworkState _network = NetworkState.online;
  NetworkState get network => _network;

  bool _loading = false;
  bool get loading => _loading;

  List<Map<String, dynamic>> _queue = [];
  int get pending => _queue.length;

  bool _isSyncing = false; // Single Instance Thread-Storm Guard
  Timer? _syncTimer;

  /// Calculated Profile Strength Scoring Metric
  double get completionScore {
    if (_profile == null) return 0.0;
    int score = 0;

    if (_profile!.stageName.trim().isNotEmpty && _profile!.stageName != 'New Creator') score++;
    if (_profile!.bio.trim().isNotEmpty && _profile!.bio != 'Afrobeat artist • Creative storyteller') score++;
    if (_profile!.avatarUrl != null && _profile!.avatarUrl!.trim().isNotEmpty) score++;
    if (_profile!.username.trim().isNotEmpty) score++;

    return score / 4;
  }

  Future<void> init() async {
    _queue = await _storage.load();
    _startSyncEngine();
    await syncProfile();
  }

  Future<void> syncProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    _loading = true;
    notifyListeners();

    try {
      final data = await _client.from('profiles').select().eq('id', user.id).maybeSingle();
      if (data != null) {
        _profile = ProfileModel.fromMap(data, user.email?.split('@')[0] ?? "user");
      }
    } catch (e) {
      debugPrint('⚠️ Fetch error or profile offline: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void _optimisticUpdate(Map<String, dynamic> patch) {
    if (_profile == null) return;
    _profile = _profile!.copyWith(
      stageName: patch["stage_name"] ?? _profile!.stageName,
      bio: patch["bio"] ?? _profile!.bio,
      avatarUrl: patch["avatar_url"] ?? _profile!.avatarUrl,
    );
    notifyListeners();
  }

  Future<void> saveProfile({
    required String stageName,
    required String bio,
    String? avatarUrl,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final payload = {
      "id": user.id,
      "stage_name": stageName,
      "bio": bio,
      "avatar_url": avatarUrl,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };

    // 1. Fire Optimistic UI change instantly
    _optimisticUpdate(payload);

    // 2. Commit payload to local disk database queue safely
    _queue.add(payload);
    await _storage.save(_queue);

    // 3. Request immediate execution sweep pass safely
    _syncNow();
  }

  Future<String?> uploadImage(File file) async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;
      
      final path = "avatars/${user.id}/${DateTime.now().millisecondsSinceEpoch}.jpg";
      await _client.storage.from('avatars').upload(path, file);
      return _client.storage.from('avatars').getPublicUrl(path);
    } catch (e) {
      debugPrint('🚨 Storage Upload Error: $e');
      return null;
    }
  }

  /// Thread Safe Core Execution Sync Engine Pass
  Future<void> _syncNow() async {
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

      // On successful database response, trim the persistent array layout
      _queue.removeAt(0);
      await _storage.save(_queue);
      _backoff.reset();
      
      _isSyncing = false;
      notifyListeners();

      // Chain process remaining backlog targets sequentially down the pipeline
      if (_queue.isNotEmpty) {
        _syncNow();
      }
    } catch (e) {
      _isSyncing = false;
      debugPrint('⚠️ Sync delayed, retry backoff sequence triggered: $e');
      
      final delay = _backoff.nextDelay();
      _syncTimer?.cancel();
      _syncTimer = Timer(delay, _syncNow);
    }
  }

  void _startSyncEngine() {
    Timer.periodic(const Duration(seconds: 15), (_) async {
      if (_queue.isNotEmpty && !_isSyncing) {
        await _syncNow();
      }
    });
  }

  void setNetwork(NetworkState state) {
    _network = state;
    if (_network == NetworkState.online) {
      _syncNow();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}
