import 'package:freezed_annotation/freezed_annotation.dart';
import 'content_model.dart';

part 'playback_state_model.freezed.dart';

@freezed
class PlaybackStateModel with _$PlaybackStateModel {
  const factory PlaybackStateModel({
    ContentModel? currentTrack,
    @Default(false) bool isPlaying,
    @Default(false) bool isBuffering,

    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration duration,

    @Default([]) List<ContentModel> queue,
  }) = _PlaybackStateModel;
}
