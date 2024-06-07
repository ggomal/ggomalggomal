import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> setJwt(String jwt) async {
    await _storage.write(key: 'jwt', value: jwt);
  }

  Future<String?> getJwt() async {
    return await _storage.read(key: 'jwt');
  }

  Future<void> setRole(String role) async {
    await _storage.write(key: 'role', value: role);
  }

  Future<String?> getRole() async {
    return await _storage.read(key: 'role');
  }

  Future<void> setName(String name) async {
    await _storage.write(key: 'name', value: name);
  }

  Future<String?> getName() async {
    return await _storage.read(key: 'name');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
    await _storage.delete(key: 'role');
    await _storage.delete(key: 'name');
  }
}
