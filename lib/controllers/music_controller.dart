import 'package:flutter/foundation.dart';

import '../models/music_model.dart';
import '../repositories/music_repository.dart';

class MusicController extends ChangeNotifier {
  final MusicRepository _repo = MusicRepository.instance;

  List<MusicModel> _songs = [];

  bool _loading = false;

  List<MusicModel> get songs => _songs;

  bool get loading => _loading;

  Future<void> loadFeed() async {
    _loading = true;
    notifyListeners();

    _songs = await _repo.fetchLatestMusic();

    _loading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadFeed();
  }
}
