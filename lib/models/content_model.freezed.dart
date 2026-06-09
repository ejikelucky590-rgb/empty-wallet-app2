// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContentModel _$ContentModelFromJson(Map<String, dynamic> json) {
  return _ContentModel.fromJson(json);
}

/// @nodoc
mixin _$ContentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'content_url')
  String get contentUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'views_count')
  int get viewsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'profiles')
  Map<String, dynamic>? get profile => throw _privateConstructorUsedError;

  /// Serializes this ContentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ContentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentModelCopyWith<ContentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentModelCopyWith<$Res> {
  factory $ContentModelCopyWith(
          ContentModel value, $Res Function(ContentModel) then) =
      _$ContentModelCopyWithImpl<$Res, ContentModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String type,
      String title,
      @JsonKey(name: 'content_url') String contentUrl,
      String? description,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'views_count') int viewsCount,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'profiles') Map<String, dynamic>? profile});
}

/// @nodoc
class _$ContentModelCopyWithImpl<$Res, $Val extends ContentModel>
    implements $ContentModelCopyWith<$Res> {
  _$ContentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ContentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? contentUrl = null,
    Object? description = freezed,
    Object? thumbnailUrl = freezed,
    Object? viewsCount = null,
    Object? createdAt = null,
    Object? profile = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      contentUrl: null == contentUrl
          ? _value.contentUrl
          : contentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContentModelImplCopyWith<$Res>
    implements $ContentModelCopyWith<$Res> {
  factory _$$ContentModelImplCopyWith(
          _$ContentModelImpl value, $Res Function(_$ContentModelImpl) then) =
      __$$ContentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String type,
      String title,
      @JsonKey(name: 'content_url') String contentUrl,
      String? description,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'views_count') int viewsCount,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'profiles') Map<String, dynamic>? profile});
}

/// @nodoc
class __$$ContentModelImplCopyWithImpl<$Res>
    extends _$ContentModelCopyWithImpl<$Res, _$ContentModelImpl>
    implements _$$ContentModelImplCopyWith<$Res> {
  __$$ContentModelImplCopyWithImpl(
      _$ContentModelImpl _value, $Res Function(_$ContentModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ContentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? title = null,
    Object? contentUrl = null,
    Object? description = freezed,
    Object? thumbnailUrl = freezed,
    Object? viewsCount = null,
    Object? createdAt = null,
    Object? profile = freezed,
  }) {
    return _then(_$ContentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      contentUrl: null == contentUrl
          ? _value.contentUrl
          : contentUrl // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profile: freezed == profile
          ? _value._profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContentModelImpl implements _ContentModel {
  const _$ContentModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.type,
      required this.title,
      @JsonKey(name: 'content_url') required this.contentUrl,
      this.description,
      @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
      @JsonKey(name: 'views_count') this.viewsCount = 0,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'profiles') final Map<String, dynamic>? profile})
      : _profile = profile;

  factory _$ContentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String type;
  @override
  final String title;
  @override
  @JsonKey(name: 'content_url')
  final String contentUrl;
  @override
  final String? description;
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @override
  @JsonKey(name: 'views_count')
  final int viewsCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final Map<String, dynamic>? _profile;
  @override
  @JsonKey(name: 'profiles')
  Map<String, dynamic>? get profile {
    final value = _profile;
    if (value == null) return null;
    if (_profile is EqualUnmodifiableMapView) return _profile;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ContentModel(id: $id, userId: $userId, type: $type, title: $title, contentUrl: $contentUrl, description: $description, thumbnailUrl: $thumbnailUrl, viewsCount: $viewsCount, createdAt: $createdAt, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.contentUrl, contentUrl) ||
                other.contentUrl == contentUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._profile, _profile));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      type,
      title,
      contentUrl,
      description,
      thumbnailUrl,
      viewsCount,
      createdAt,
      const DeepCollectionEquality().hash(_profile));

  /// Create a copy of ContentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentModelImplCopyWith<_$ContentModelImpl> get copyWith =>
      __$$ContentModelImplCopyWithImpl<_$ContentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContentModelImplToJson(
      this,
    );
  }
}

abstract class _ContentModel implements ContentModel {
  const factory _ContentModel(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          required final String type,
          required final String title,
          @JsonKey(name: 'content_url') required final String contentUrl,
          final String? description,
          @JsonKey(name: 'thumbnail_url') final String? thumbnailUrl,
          @JsonKey(name: 'views_count') final int viewsCount,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'profiles') final Map<String, dynamic>? profile}) =
      _$ContentModelImpl;

  factory _ContentModel.fromJson(Map<String, dynamic> json) =
      _$ContentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get type;
  @override
  String get title;
  @override
  @JsonKey(name: 'content_url')
  String get contentUrl;
  @override
  String? get description;
  @override
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @override
  @JsonKey(name: 'views_count')
  int get viewsCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'profiles')
  Map<String, dynamic>? get profile;

  /// Create a copy of ContentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentModelImplCopyWith<_$ContentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
