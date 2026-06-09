import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import '../models/content_model.dart';

// State definition for the audio player
class AudioState {
  final ContentModel? currentTrack;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  AudioState({
    this.currentTrack,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });
}

// Controller Logic
class AudioController extends Notifier<AudioState> {
  late final AudioPlayer _player;

  @override
  AudioState build() {
    _player = AudioPlayer();
    
    // Listen to player streams to update state automatically
    _player.playerStateStream.listen((playerState) {
      state = AudioState(
        currentTrack: state.currentTrack,
        isPlaying: playerState.playing,
        position: state.position,
        duration: state.duration,
      );
    });

    return AudioState();
  }

  Future<void> playTrack(ContentModel track, {List<ContentModel>? queue}) async {
    // Logic to set source and play
    await _player.setUrl(track.contentUrl);
    await _player.play();
    state = AudioState(currentTrack: track, isPlaying: true);
  }

  Future<void> togglePlayPause() async {
    try {
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } catch (e) {
      // Handle potential playback errors
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> playNext() async {
    // Add skip next logic
  }

  Future<void> playPrevious() async {
    // Add skip previous logic
  }
}

// Global provider for the controller
final audioControllerProvider = NotifierProvider<AudioController, AudioState>(() {
  return AudioController();
});
