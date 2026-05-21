import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

// Modular Relative Imports
import '../../models/music/track_model.dart';
import 'playback_status.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;

  AudioPlayerService._internal() {
    _initialize();
  }

  final AudioPlayer _player = AudioPlayer();
  final _trackController = StreamController<Track?>.broadcast();
  final _playbackController = StreamController<PlaybackStatus>.broadcast();
  
  Track? _currentTrack;

  Stream<Track?> get currentTrackStream => _trackController.stream;
  Stream<PlaybackStatus> get playbackStream => _playbackController.stream;
  AudioPlayer get player => _player;
  Track? get currentTrack => _currentTrack;

  Future<void> _initialize() async {
    if (!kIsWeb) {
      final session = await AudioSession.instance;
      await session.configure(
        const AudioSessionConfiguration.music(),
      );
    }

    _player.playerStateStream.listen(_handlePlayerState);
    _player.processingStateStream.listen(_handleProcessingState);
  }

  void _handlePlayerState(PlayerState state) {
    if (state.playing) {
      _playbackController.add(PlaybackStatus.playing);
    } else {
      _playbackController.add(PlaybackStatus.paused);
    }
  }

  void _handleProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.loading:
        _playbackController.add(PlaybackStatus.loading);
        break;
      case ProcessingState.buffering:
        _playbackController.add(PlaybackStatus.buffering);
        break;
      case ProcessingState.completed:
        _playbackController.add(PlaybackStatus.completed);
        break;
      default:
        break;
    }
  }

  Stream<PositionData> get positionDataStream {
    return StreamTransformer<Duration, PositionData>.fromHandlers(
      handleData: (position, sink) {
        sink.add(PositionData(
          position: position,
          bufferedPosition: _player.bufferedPosition,
          duration: _player.duration ?? Duration.zero,
        ));
      },
    ).bind(_player.positionStream);
  }

  Future<void> playTrack(Track track) async {
    try {
      _currentTrack = track;
      _trackController.add(track);
      _playbackController.add(PlaybackStatus.loading);

      await _player.setUrl(track.audioUrl);
      await _player.play();
    } catch (_) {
      _playbackController.add(PlaybackStatus.error);
    }
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> skipForward() async {
    final newPosition = _player.position + const Duration(seconds: 10);
    await seek(newPosition);
  }

  Future<void> skipBackward() async {
    final newPosition = _player.position - const Duration(seconds: 10);
    await seek(newPosition.isNegative ? Duration.zero : newPosition);
  }

  Future<void> stop() async {
    await _player.stop();
    _playbackController.add(PlaybackStatus.idle);
  }

  Future<void> dispose() async {
    await _trackController.close();
    await _playbackController.close();
    await _player.dispose();
  }
}
