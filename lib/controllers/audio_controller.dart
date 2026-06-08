import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../models/content_model.dart';
import '../models/playback_state_model.dart';

class AudioController extends Notifier<PlaybackStateModel> {
  late final AudioPlayer _player;

  @override
  PlaybackStateModel build() {
    _player = AudioPlayer();

    // Listen to playback completion → auto next
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });

    return const PlaybackStateModel();
  }

  // 🎵 PLAY TRACK + SET QUEUE
  Future<void> playTrack(
    ContentModel track, {
    List<ContentModel>? queue,
  }) async {
    final newQueue = queue ?? state.queue;

    await _player.setUrl(track.content_url);
    await _player.play();

    state = state.copyWith(
      currentTrack: track,
      queue: newQueue,
      isPlaying: true,
      position: Duration.zero,
    );
  }

  // ⏯ TOGGLE PLAY/PAUSE
  Future<void> toggle() async {
    if (_player.playing) {
      await _player.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      await _player.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  // ⏭ NEXT TRACK (CORE LOGIC)
  Future<void> playNext() async {
    final current = state.currentTrack;
    final queue = state.queue;

    if (current == null || queue.isEmpty) return;

    final index = queue.indexWhere((t) => t.id == current.id);

    if (index == -1 || index + 1 >= queue.length) return;

    final nextTrack = queue[index + 1];

    await playTrack(
      nextTrack,
      queue: queue,
    );
  }

  // ⏮ PREVIOUS TRACK
  Future<void> playPrevious() async {
    final current = state.currentTrack;
    final queue = state.queue;

    if (current == null || queue.isEmpty) return;

    final index = queue.indexWhere((t) => t.id == current.id);

    if (index <= 0) return;

    final prevTrack = queue[index - 1];

    await playTrack(
      prevTrack,
      queue: queue,
    );
  }

  // 🎯 SEEK
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    state = state.copyWith(position: position);
  }
}
