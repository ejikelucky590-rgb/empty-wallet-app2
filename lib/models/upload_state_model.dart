import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_state_model.freezed.dart';

@freezed
class UploadStateModel with _$UploadStateModel {
  const factory UploadStateModel({
    @Default(false) bool isUploading,
    @Default(0.0) double progress,
    String? error,
    String? successMessage,
  }) = _UploadStateModel;
}
