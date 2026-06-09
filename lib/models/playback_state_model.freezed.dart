// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlaybackStateModel {
  ContentModel? get currentTrack => throw _privateConstructorUsedError;
  bool get isPlaying => throw _privateConstructorUsedError;
  bool get isBuffering => throw _privateConstructorUsedError;
  Duration get position => throw _privateConstructorUsedError;
  Duration get duration => throw _privateConstructorUsedError;
  List<ContentModel> get queue => throw _privateConstructorUsedError;

  /// Create a copy of PlaybackStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaybackStateModelCopyWith<PlaybackStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaybackStateModelCopyWith<$Res> {
  factory $PlaybackStateModelCopyWith(
          PlaybackStateModel value, $Res Function(PlaybackStateModel) then) =
      _$PlaybackStateModelCopyWithImpl<$Res, PlaybackStateModel>;
  @useResult
  $Res call(
      {ContentModel? currentTrack,
      bool isPlaying,
      bool isBuffering,
      Duration position,
      Duration duration,
      List<ContentModel> queue});

  $ContentModelCopyWith<$Res>? get currentTrack;
}

/// @nodoc
class _$PlaybackStateModelCopyWithImpl<$Res, $Val extends PlaybackStateModel>
    implements $PlaybackStateModelCopyWith<$Res> {
  _$PlaybackStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaybackStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTrack = freezed,
    Object? isPlaying = null,
    Object? isBuffering = null,
    Object? position = null,
    Object? duration = null,
    Object? queue = null,
  }) {
    return _then(_value.copyWith(
      currentTrack: freezed == currentTrack
          ? _value.currentTrack
          : currentTrack // ignore: cast_nullable_to_non_nullable
              as ContentModel?,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      isBuffering: null == isBuffering
          ? _value.isBuffering
          : isBuffering // ignore: cast_nullable_to_non_nullable
              as bool,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Duration,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      queue: null == queue
          ? _value.queue
          : queue // ignore: cast_nullable_to_non_nullable
              as List<ContentModel>,
    ) as $Val);
  }

  /// Create a copy of PlaybackStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ContentModelCopyWith<$Res>? get currentTrack {
    if (_value.currentTrack == null) {
      return null;
    }

    return $ContentModelCopyWith<$Res>(_value.currentTrack!, (value) {
      return _then(_value.copyWith(currentTrack: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaybackStateModelImplCopyWith<$Res>
    implements $PlaybackStateModelCopyWith<$Res> {
  factory _$$PlaybackStateModelImplCopyWith(_$PlaybackStateModelImpl value,
          $Res Function(_$PlaybackStateModelImpl) then) =
      __$$PlaybackStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ContentModel? currentTrack,
      bool isPlaying,
      bool isBuffering,
      Duration position,
      Duration duration,
      List<ContentModel> queue});

  @override
  $ContentModelCopyWith<$Res>? get currentTrack;
}

/// @nodoc
class __$$PlaybackStateModelImplCopyWithImpl<$Res>
    extends _$PlaybackStateModelCopyWithImpl<$Res, _$PlaybackStateModelImpl>
    implements _$$PlaybackStateModelImplCopyWith<$Res> {
  __$$PlaybackStateModelImplCopyWithImpl(_$PlaybackStateModelImpl _value,
      $Res Function(_$PlaybackStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlaybackStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTrack = freezed,
    Object? isPlaying = null,
    Object? isBuffering = null,
    Object? position = null,
    Object? duration = null,
    Object? queue = null,
  }) {
    return _then(_$PlaybackStateModelImpl(
      currentTrack: freezed == currentTrack
          ? _value.currentTrack
          : currentTrack // ignore: cast_nullable_to_non_nullable
              as ContentModel?,
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      isBuffering: null == isBuffering
          ? _value.isBuffering
          : isBuffering // ignore: cast_nullable_to_non_nullable
              as bool,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Duration,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      queue: null == queue
          ? _value._queue
          : queue // ignore: cast_nullable_to_non_nullable
              as List<ContentModel>,
    ));
  }
}

/// @nodoc

class _$PlaybackStateModelImpl implements _PlaybackStateModel {
  const _$PlaybackStateModelImpl(
      {this.currentTrack,
      this.isPlaying = false,
      this.isBuffering = false,
      this.position = Duration.zero,
      this.duration = Duration.zero,
      final List<ContentModel> queue = const []})
      : _queue = queue;

  @override
  final ContentModel? currentTrack;
  @override
  @JsonKey()
  final bool isPlaying;
  @override
  @JsonKey()
  final bool isBuffering;
  @override
  @JsonKey()
  final Duration position;
  @override
  @JsonKey()
  final Duration duration;
  final List<ContentModel> _queue;
  @override
  @JsonKey()
  List<ContentModel> get queue {
    if (_queue is EqualUnmodifiableListView) return _queue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_queue);
  }

  @override
  String toString() {
    return 'PlaybackStateModel(currentTrack: $currentTrack, isPlaying: $isPlaying, isBuffering: $isBuffering, position: $position, duration: $duration, queue: $queue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaybackStateModelImpl &&
            (identical(other.currentTrack, currentTrack) ||
                other.currentTrack == currentTrack) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.isBuffering, isBuffering) ||
                other.isBuffering == isBuffering) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other._queue, _queue));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentTrack,
      isPlaying,
      isBuffering,
      position,
      duration,
      const DeepCollectionEquality().hash(_queue));

  /// Create a copy of PlaybackStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaybackStateModelImplCopyWith<_$PlaybackStateModelImpl> get copyWith =>
      __$$PlaybackStateModelImplCopyWithImpl<_$PlaybackStateModelImpl>(
          this, _$identity);
}

abstract class _PlaybackStateModel implements PlaybackStateModel {
  const factory _PlaybackStateModel(
      {final ContentModel? currentTrack,
      final bool isPlaying,
      final bool isBuffering,
      final Duration position,
      final Duration duration,
      final List<ContentModel> queue}) = _$PlaybackStateModelImpl;

  @override
  ContentModel? get currentTrack;
  @override
  bool get isPlaying;
  @override
  bool get isBuffering;
  @override
  Duration get position;
  @override
  Duration get duration;
  @override
  List<ContentModel> get queue;

  /// Create a copy of PlaybackStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaybackStateModelImplCopyWith<_$PlaybackStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
