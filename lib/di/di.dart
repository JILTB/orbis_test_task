import 'package:get_it/get_it.dart';
import 'package:orbis_test_task/misc/config.dart';
import 'package:orbis_test_task/repositories/network_repository.dart';
import 'package:orbis_test_task/services/http/api.dart';
import 'package:orbis_test_task/services/http/http_client.dart';
import 'package:orbis_test_task/services/network_service.dart';
import 'package:orbis_test_task/services/secure_storage_service.dart';
import 'package:orbis_test_task/view_models/login_screen_view_model.dart';
import 'package:orbis_test_task/view_models/user_list_view_view_model.dart';

class DI {
  DI._();

  static T resolve<T extends Object>() => GetIt.instance<T>();

  static Future<void> initialize() async {
    await _registerPersistence();
    await _registerApis();
    _registerRepositories();
    _registerServices();
    _registerViewModels();
  }

  static Future<void> _registerPersistence() async {
    GetIt.instance.registerSingleton(SecureStoreService());
  }

  static Future<void> _registerApis() async {
    GetIt.instance
      ..registerSingleton(
        HttpClient(
          baseUrl: Config.baseUrl,
        ),
      )
      ..registerSingleton(
        Api(
          resolve(),
        ),
      );
  }

  static void _registerRepositories() {
    GetIt.instance.registerSingleton(
      NetworkRepository(
        resolve(),
      ),
    );
  }

  static void _registerServices() {
    GetIt.instance.registerSingleton(
      NetworkService(
        resolve(),
        resolve(),
      ),
    );
  }

  static void _registerViewModels() {
    GetIt.instance
      ..registerFactory<LoginScreenViewModelType>(
        () => LoginScreenViewModel(
          resolve(),
        ),
      )
      ..registerFactory<UserListViewModelType>(
        () => UserListViewModel(
          resolve(),
          resolve(),
        ),
      );
  }
}
