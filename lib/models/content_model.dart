import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_model.freezed.dart';
part 'content_model.g.dart';

@freezed
class ContentModel with _$ContentModel {
  const factory ContentModel({
    required String id,

    @JsonKey(name: 'user_id')
    required String userId,

    required String type,

    required String title,

    @JsonKey(name: 'content_url')
    required String contentUrl,

    String? description,

    @JsonKey(name: 'thumbnail_url')
    String? thumbnailUrl,

    @JsonKey(name: 'views_count')
    @Default(0)
    int viewsCount,

    @JsonKey(name: 'created_at')
    required DateTime createdAt,

    @JsonKey(name: 'profiles')
    Map<String, dynamic>? profile,
  }) = _ContentModel;

  factory ContentModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ContentModelFromJson(json);
}
