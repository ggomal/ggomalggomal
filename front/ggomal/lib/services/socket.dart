import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ggomal/login_storage.dart';


class SocketDio {
  static WebSocketChannel? _channel;
  static Stream? _broadcastStream;
  static bool _isConnected = false;

  // static Future<void> connectToWebSocket() async {
  //   if (!_isConnected) {
  //     try {
  //       var headers = await getWebSocketHeadersAsync();
  //       _channel = IOWebSocketChannel.connect(
  //         Uri.parse(getWebSocketUrl()),
  //         headers: headers,
  //       );
  //       _broadcastStream = _channel!.stream.asBroadcastStream();
  //       _isConnected = true;
  //
  //       _broadcastStream!.listen((message) {
  //         recievedMessage(message);
  //       });
  //     } catch (e) {
  //       print('WebSocket 연결 실패했음 socket.dart를 확인하세요: $e');
  //       _isConnected = false;
  //     }
  //   }
  // }
  //
  // static void disconnectWebSocket() {
  //   if (_isConnected && _channel != null) {
  //     _channel!.sink.close();
  //     _isConnected = false;
  //   }
  // }

  static Stream? get broadcastStream => _broadcastStream;

  static String getWebSocketUrl() {
    return 'wss://k10e206.p.ssafy.io/api/v1/room';
  }

  static Future<Map<String, dynamic>> getWebSocketHeadersAsync() async {
    LoginStorage _storage = LoginStorage();
    String? loginJwt = await _storage.getJwt();
    return {'Authorization': 'Bearer $loginJwt'};
  }

  // static void recievedMessage(dynamic message) {
  //   try {
  //     var decodedMessage = jsonDecode(message);
  //     switch (decodedMessage['action']) {
  //       case 'SET_BINGO_BOARD':
  //       // 빙고 데이터 받아오는거
  //         break;
  //       case 'FIND_LETTER':
  //       // 애기 빙고 찾게하는거
  //         break;
  //       default:
  //         print('받는 : ${decodedMessage['type']}');
  //     }
  //   } catch (e) {
  //     print('메시지 처리 중 에러 발생: $e');
  //   }
  // }
}
