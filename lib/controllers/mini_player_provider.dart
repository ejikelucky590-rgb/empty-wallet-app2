import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/playback_state_model.dart';
import 'audio_controller.dart';

final miniPlayerProvider = Provider<PlaybackStateModel>((ref) {
  return ref.watch(audioControllerProvider);
});
