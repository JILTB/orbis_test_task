import 'package:orbis_test_task/misc/result.dart';
import 'package:orbis_test_task/models/login_model.dart';
import 'package:orbis_test_task/models/user_list_model.dart';
import 'package:orbis_test_task/services/http/api.dart';

class NetworkRepository {
  NetworkRepository(this._api);

  final Api _api;

  Future<Result<String?>> login(LoginModel loginModel) =>
      _api.login(loginModel);

  Future<Result<List<Data>?>> load(int page) =>
      _api.loadUsers(page).mapResult((list) => list.data);
}
