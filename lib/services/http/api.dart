import 'package:orbis_test_task/misc/result.dart';
import 'package:orbis_test_task/models/login_model.dart';
import 'package:orbis_test_task/models/network/requests/login_request_model.dart';
import 'package:orbis_test_task/models/network/requests/user_list_request_model.dart';
import 'package:orbis_test_task/models/token_model.dart';
import 'package:orbis_test_task/models/user_list_model.dart';
import 'package:orbis_test_task/services/http/base_api.dart';

class Api extends BaseApi {
  Api(super.httpClient);

  Future<Result<String?>> login(LoginModel loginModel) async {
    final request = LoginRequestModel(loginModel: loginModel);

    return await makeRequest(request,
        mapper: (json) => TokenModel.fromJson(json).token);
  }

  Future<Result<UserListModel>> loadUsers(int page) {
    final request = UserListRequestModel(page: page);
    return makeRequest(request, mapper: (json) => UserListModel.fromJson(json));
  }
}
