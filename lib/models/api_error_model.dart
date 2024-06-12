import 'package:freezed_annotation/freezed_annotation.dart';
part 'api_error_model.freezed.dart';
part 'api_error_model.g.dart';

@freezed
class ApiErrorModel with _$ApiErrorModel {
  const factory ApiErrorModel({
    String? error,
  }) = _ApiErrorModel;

  factory ApiErrorModel.fromJson(Map<String, Object?> json) =>
      _$ApiErrorModelFromJson(json);
}
