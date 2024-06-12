import 'package:orbis_test_task/models/login_model.dart';
import 'package:orbis_test_task/models/network/requests/base_request_model.dart';

class LoginRequestModel extends BaseRequestModel {
  LoginRequestModel({required this.loginModel});

  final LoginModel loginModel;

  @override
  String get path => 'api/login';

  @override
  MethodType get type => MethodType.post;

  @override
  Map<String, dynamic> get body => loginModel.toJson();
}
