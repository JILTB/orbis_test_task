import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStoreService {
  SecureStoreService();

  final _storage = const FlutterSecureStorage();

  // Future<String?> _get({required String key}) {
  //   return _storage.read(key: key);
  // }

  Future<void> _store({required String key, required String? value}) {
    if (value == null) {
      return _storage.delete(key: key);
    }
    return _storage.write(key: key, value: value);
  }

  Future<void> setEmail(String? email) =>
      _store(key: _StoreKeys.username, value: email);

  Future<void> setToken(String? token) =>
      _store(key: _StoreKeys.token, value: token);
}

abstract class _StoreKeys {
  static const username = 'username';
  static const token = 'token';
}
