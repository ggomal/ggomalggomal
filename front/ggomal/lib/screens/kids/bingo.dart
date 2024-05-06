import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class RoomId with ChangeNotifier {
  String? _roomId;
  String? get roomId => _roomId;
  set roomId(String? newRoomId) {
    _roomId = newRoomId;
    notifyListeners();
  }
}

class BingoScreen extends StatefulWidget {
  const BingoScreen({super.key});

  @override
  State<BingoScreen> createState() => _BingoScreenState();
}

class _BingoScreenState extends State<BingoScreen> {
  late final WebSocketChannel channel;
  bool isConnected = false;
  // String? roomId;
  String? roomId = '7f6d91cf-25fb-47bc-aca2-c029f0e4bbc9';
  int recordCount = 0;
  late String currentFilePath;

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
    initRecorder();
  }

  final recorder = FlutterSoundRecorder();
  Future initRecorder() async {
    // final status = await Permission.microphone.request();
    var status = await Permission.speech.status;
    if (!status.isGranted) {
      print('권한 허용안됨');
      throw '마이크 권한이 허용되지 않았습니다';
    }
    await recorder.openRecorder();
  }

  Future<void> record() async {
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/audio_$recordCount.aac';
    await recorder.startRecorder(toFile: filePath);
    setState(() {
      currentFilePath = filePath;
    });
    print('녹음하기');
  }
  Future<void> stop() async {
    await recorder.stopRecorder();
    setState(() {
      recordCount++;
    });
    print('녹음종료됨');
  }

  void connectToWebSocket() {
    if (!isConnected) {
      channel = IOWebSocketChannel.connect(
          Uri.parse('wss://k10e206.p.ssafy.io/api/v1/room'),
          headers: {
            "authorization": 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJjZW50ZXJJZCI6Miwicm9sZSI6IktJRCIsIm1lbWJlck5hbWUiOiLrp4jripjslYTsnbQiLCJtZW1iZXJJZCI6NCwic3ViIjoia2lkMSIsImlhdCI6MTcxNDkxMjg4MiwiZXhwIjoxMDE3MTQ5MTI4ODJ9.poP4jnnsdQhINLLD5RM9zDQNFcsJ_LQ57PDqB0exdJ8',
          });
      channel.stream.listen((response) {
        print('웹소켓 응답 : $response');
        Map<String, dynamic> message = jsonDecode(response);
        roomId = message['roomId'];
        print("수신된 룸 아이디 : $roomId");

      }, onDone: () {
        print('연결 종료 ');
      }, onError: (error) {
        print('소켓 통신에 실패했습니다. $error');
      });
      channel.sink.add(
          '{"type" : "createRoom"}'
      );
      // print('소켓 연결이 처음 성공 시 출력 ');
      isConnected = true;
    }
  }

  Future<void> sendLastAudio() async {
    print(currentFilePath);
    if (currentFilePath.isNotEmpty) {
      var request = http.MultipartRequest('POST', Uri.parse('https://k10e206.p.ssafy.io/api/v1/bear/evaluation'));
      request.files.add(await http.MultipartFile.fromPath('files', currentFilePath));
      var response = await request.send();
      if (response.statusCode == 200) {
        print('녹음 전송됨');
      } else {
        var httpResponse = await http.Response.fromStream(response);
        print('녹음 전송 실패: ${httpResponse.body}');
      }
    }
  }

  @override
  void dispose() {
    channel.sink.close(status.goingAway);
    super.dispose();
    recorder.closeRecorder();
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

            // 임시 버튼
            Positioned(
              right: 0,
              top : 100,
              child: ElevatedButton(
                onPressed: () async{
                  if (recorder.isRecording) {
                    await stop();
                  } else {
                    await record();
                  }
                },
                child: Text(recorder.isRecording ? '녹음종료' : '녹음하기'),
              ),
            ),
            Positioned(
              right: 0,
              top : 200,
              child: ElevatedButton(
                onPressed: sendLastAudio,
                child: Text('통과'),
              ),
            ),
          ]),
        ));
  }
}
