import 'dart:developer';

import 'package:orbis_test_task/misc/stream_extensions.dart';
import 'package:orbis_test_task/models/user_list_model.dart';
import 'package:orbis_test_task/services/network_service.dart';
import 'package:orbis_test_task/services/secure_storage_service.dart';
import 'package:rxdart/rxdart.dart';

import 'base_view_model.dart';

abstract class UserListViewModelInput {
  void loadUserList(int page);

  void logout();
}

abstract class UserListViewModelOutput {
  Stream<List<Data>?> get userList;

  Stream<bool> get shouldPop;

  Stream<String?> get toastMessage;
}

abstract class UserListViewModelType extends BaseViewModel {
  UserListViewModelInput get input;

  UserListViewModelOutput get output;
}

class UserListViewModel
    implements
        UserListViewModelType,
        UserListViewModelInput,
        UserListViewModelOutput {
  UserListViewModel(
    this._networkService,
    this._secureStoreService,
  ) {
    final loadAnyData = _loadAdditionalDataTrigger
        .asyncMap((page) async => _networkService.load(page))
        .shareReplay(maxSize: 1);
    loadAnyData.whereSuccess();

    userList = loadAnyData.whereSuccess().shareReplay(maxSize: 1);

    toastMessage = Rx.merge(
      [
        loadAnyData.whereError().map((error) => error.description),
        userList
            .whereNotNull()
            .map((list) => list.isEmpty ? 'no more data to load' : null)
      ],
    );

    shouldPop = _logoutTrigger.map(
      (shouldPop) {
        _secureStoreService.setToken(null);
        log('token Cleared');
        return true;
      },
    );
  }

  final _loadAdditionalDataTrigger = BehaviorSubject<int>();
  final _logoutTrigger = BehaviorSubject<bool>();

  final NetworkService _networkService;
  final SecureStoreService _secureStoreService;

  @override
  UserListViewModelInput get input => this;

  @override
  UserListViewModelOutput get output => this;

  @override
  void loadUserList(int page) {
    _loadAdditionalDataTrigger.add(page);
  }

  @override
  void logout() {
    _logoutTrigger.add(true);
  }

  @override
  void dispose() {
    _loadAdditionalDataTrigger.close();
    _logoutTrigger.close();
  }

  @override
  late final Stream<List<Data>?> userList;

  @override
  late final Stream<bool> shouldPop;

  @override
  late final Stream<String?> toastMessage;
}
