import 'package:ggomal/login_storage.dart';

class SocketDio {
  static String getWebSocketUrl() {
    return 'wss://k10e206.p.ssafy.io/api/v1/room';
  }

  static Future<Map<String, dynamic>> getWebSocketHeadersAsync() async {
    LoginStorage _storage = LoginStorage();
    String? loginJwt = await _storage.getJwt();
    return {'Authorization': 'Bearer $loginJwt'};
  }
}
