import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_list_model.freezed.dart';
part 'user_list_model.g.dart';

@freezed
class UserListModel with _$UserListModel {
  const factory UserListModel({
    @JsonKey(name: 'page') int? page,
    @JsonKey(name: 'per_page') int? perPage,
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'total_pages') int? totalPages,
    @JsonKey(name: 'data') List<Data>? data,
    @JsonKey(name: 'support') Support? support,
  }) = _UserListModel;

  factory UserListModel.fromJson(Map<String, Object?> json) =>
      _$UserListModelFromJson(json);
}

@freezed
class Data with _$Data {
  const factory Data({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'avatar') String? avatar,
  }) = _Data;

  factory Data.fromJson(Map<String, Object?> json) => _$DataFromJson(json);
}

@freezed
class Support with _$Support {
  const factory Support({
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'text') String? text,
  }) = _Support;

  factory Support.fromJson(Map<String, Object?> json) =>
      _$SupportFromJson(json);
}
