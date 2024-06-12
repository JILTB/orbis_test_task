import 'package:orbis_test_task/misc/result.dart';
import 'package:orbis_test_task/models/login_model.dart';
import 'package:orbis_test_task/models/user_list_model.dart';
import 'package:orbis_test_task/repositories/network_repository.dart';
import 'package:orbis_test_task/services/secure_storage_service.dart';

class NetworkService {
  final NetworkRepository _networkRepository;
  final SecureStoreService _secureStoreService;

  NetworkService(this._networkRepository, this._secureStoreService);

  Future<Result<List<Data>?>> load(int page) async {
    return await _networkRepository.load(page);
  }

  Future<Result<String?>> login(LoginModel loginModel) async {
    return await _networkRepository
        .login(loginModel)
        .mapResult<String?>((response) async {
      if (response != null) {
        await _secureStoreService.setToken(response);
      }
    });
  }
}
