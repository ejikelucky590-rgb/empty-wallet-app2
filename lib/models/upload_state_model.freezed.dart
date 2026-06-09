// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UploadStateModel {
  bool get isUploading => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get successMessage => throw _privateConstructorUsedError;

  /// Create a copy of UploadStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadStateModelCopyWith<UploadStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadStateModelCopyWith<$Res> {
  factory $UploadStateModelCopyWith(
          UploadStateModel value, $Res Function(UploadStateModel) then) =
      _$UploadStateModelCopyWithImpl<$Res, UploadStateModel>;
  @useResult
  $Res call(
      {bool isUploading,
      double progress,
      String? error,
      String? successMessage});
}

/// @nodoc
class _$UploadStateModelCopyWithImpl<$Res, $Val extends UploadStateModel>
    implements $UploadStateModelCopyWith<$Res> {
  _$UploadStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isUploading = null,
    Object? progress = null,
    Object? error = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UploadStateModelImplCopyWith<$Res>
    implements $UploadStateModelCopyWith<$Res> {
  factory _$$UploadStateModelImplCopyWith(_$UploadStateModelImpl value,
          $Res Function(_$UploadStateModelImpl) then) =
      __$$UploadStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isUploading,
      double progress,
      String? error,
      String? successMessage});
}

/// @nodoc
class __$$UploadStateModelImplCopyWithImpl<$Res>
    extends _$UploadStateModelCopyWithImpl<$Res, _$UploadStateModelImpl>
    implements _$$UploadStateModelImplCopyWith<$Res> {
  __$$UploadStateModelImplCopyWithImpl(_$UploadStateModelImpl _value,
      $Res Function(_$UploadStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isUploading = null,
    Object? progress = null,
    Object? error = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(_$UploadStateModelImpl(
      isUploading: null == isUploading
          ? _value.isUploading
          : isUploading // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UploadStateModelImpl implements _UploadStateModel {
  const _$UploadStateModelImpl(
      {this.isUploading = false,
      this.progress = 0.0,
      this.error,
      this.successMessage});

  @override
  @JsonKey()
  final bool isUploading;
  @override
  @JsonKey()
  final double progress;
  @override
  final String? error;
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'UploadStateModel(isUploading: $isUploading, progress: $progress, error: $error, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadStateModelImpl &&
            (identical(other.isUploading, isUploading) ||
                other.isUploading == isUploading) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isUploading, progress, error, successMessage);

  /// Create a copy of UploadStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadStateModelImplCopyWith<_$UploadStateModelImpl> get copyWith =>
      __$$UploadStateModelImplCopyWithImpl<_$UploadStateModelImpl>(
          this, _$identity);
}

abstract class _UploadStateModel implements UploadStateModel {
  const factory _UploadStateModel(
      {final bool isUploading,
      final double progress,
      final String? error,
      final String? successMessage}) = _$UploadStateModelImpl;

  @override
  bool get isUploading;
  @override
  double get progress;
  @override
  String? get error;
  @override
  String? get successMessage;

  /// Create a copy of UploadStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadStateModelImplCopyWith<_$UploadStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
