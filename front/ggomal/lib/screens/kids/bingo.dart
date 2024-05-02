import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:permission_handler/permission_handler.dart';

class BingoScreen extends StatefulWidget {
  const BingoScreen({super.key});

  @override
  State<BingoScreen> createState() => _BingoScreenState();
}

class _BingoScreenState extends State<BingoScreen> {

  getPermission() async {
    var status = await Permission.speech.status;
    if (status.isGranted) {
      print('녹음 허락됨');
    } else if (status.isDenied) {
      print('녹음 거절됨');
      Permission.speech.request();
    }
  }

  late final WebSocketChannel channel;
  bool isConnected = false;
  String? roomId;

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
    getPermission();
  }

  void connectToWebSocket() {
    if (!isConnected) {
      channel = IOWebSocketChannel.connect(
          Uri.parse('ws://k10e206.p.ssafy.io/api/v1/room'),
          headers: {
            'name': 'kids',
          });
      channel.stream.listen((message) {
        print("메시지 수신 : $message");
        if (message.startsWith('Room created:')) {
          roomId = message.split('Room created: ')[1].trim();
          print("저장된 룸 아이디: $roomId");
        }
      }, onDone: () {
        print('연결 종료 ');
      }, onError: (error) {
        print('소켓 통신에 실패했습니다. $error');
      });

      channel.sink.add(
          '{"type": "createRoom"}'
      );
      print('소켓 연결이 처음 성공 시 출력 ');
      isConnected = true;
    }
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bear/bingo_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: NavBar(),
          body: Stack(children: [
            Container(
                child: Row(
              children: [
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: Container(
                            width: 200,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Color(0xffcfe4d1),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Colors.black,
                                width: 4,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '이안이',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Maplestory',
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Container(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(children: [
                    Flexible(
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Color(0xffcfe4d1),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.black,
                              width: 4,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '선생님',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Maplestory',
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Container(color: Colors.yellow),
                    )
                  ]),
                ),
                Flexible(
                  child: Container(),
                  flex: 1,
                )
              ],
            )),
            Positioned(
              left: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/bear/student.png',
                width: 250,
                height: 250,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 5,
              child: Image.asset(
                'assets/images/bear/teacher.png',
                width: 250,
                height: 250,
              ),
            ),
            
            // 녹음하는 버튼 
            Positioned(
              right: 0,
              top : 100,
              child: ElevatedButton(
                onPressed: (){},
                child: Text('녹음 버튼'),
              ),
            ),
          ]),
        ));
  }
}
