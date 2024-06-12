import 'package:orbis_test_task/models/network/requests/base_request_model.dart';

class UserListRequestModel extends BaseRequestModel {
  UserListRequestModel({required this.page});

  final int page;
  @override
  String get path => '/api/users';

  @override
  MethodType get type => MethodType.get;

  @override
  Map<String, dynamic>? get queryParameters => {
        'page': page,
      };
}
