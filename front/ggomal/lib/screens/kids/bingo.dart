import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:ggomal/widgets/kid_bingo.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:ggomal/widgets/manager_bingo.dart';
import 'package:ggomal/login_storage.dart';

class BingoScreen extends StatefulWidget {
  final WebSocketChannel channel;
  final List<List<Map<String, dynamic>>>? responseData;

  const BingoScreen({super.key, this.responseData, required this.channel});

  @override
  State<BingoScreen> createState() => _BingoScreenState();
}

class _BingoScreenState extends State<BingoScreen> {
  late final WebSocketChannel channel;
  bool isConnected = false;
  String? roomId;
  int recordCount = 0;
  late String currentFilePath;
  final LoginStorage storage = LoginStorage();


  void BingoSelect(Map<String, dynamic> thing) async {
    String? role = await storage.getRole();
    if (role == 'KID') {
      showDialog(
        context: context,
        builder: (BuildContext context) => KidBingoModal({
          "gameNum": 1,
          "wordId": "1",
          "pronunciation": thing['pronunciation'],
          "letter": thing['letter'],
          "img": thing['letterImgUrl'],
        }),
      );
    } else if (role == 'TEACHER') {
      showDialog(
        context: context,
        builder: (BuildContext context) => ManagerBingoModal({
          "gameNum": 1,
          "wordId": "1",
          "pronunciation": thing['pronunciation'],
          "letter": thing['letter'],
          "img": thing['letterImgUrl'],
        }),
      );
    } else {
      print('사용자 역할 가져오기 오류');
    }
  }

  void ManagerSelect(Map<String, dynamic> thing) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ManagerBingoModal({
        "gameNum": 1,
        "wordId": "1",
        "pronunciation": thing['pronunciation'],
        "letter": thing['letter'],
        "img": thing['letterImgUrl'],
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    channel = widget.channel;
    isConnected = true;
    initRecorder();
  }

  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    var status = await Permission.speech.status;
    if (!status.isGranted) {
      status = await Permission.speech.request();
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

  Future<void> sendLastAudio() async {
    print(currentFilePath);
    if (currentFilePath.isNotEmpty) {
      var request = http.MultipartRequest('POST',
          Uri.parse('https://k10e206.p.ssafy.io/api/v1/bear/evaluation'));
      request.files
          .add(await http.MultipartFile.fromPath('files', currentFilePath));
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

  Widget buildBingoGrid(List<List<Map<String, dynamic>>> bingoBoard) {
    var flatList = bingoBoard.expand((row) => row).toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
      ),
      itemCount: flatList.length,
      itemBuilder: (context, index) {
        int row = index ~/ 3;
        int col = index % 3;
        var cell = flatList[index];
        return InkWell(
            onTap: () {
              sendWebSocketMessage(cell['letter']);
              BingoSelect(cell);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 2),
                image: DecorationImage(
                  image: NetworkImage(
                      cell['letterImgUrl'] ?? 'assets/images/placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                cell['letter'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ));
      },
    );
  }

  Future<void> sendWebSocketMessage(String letter) async {
    if (channel != null && isConnected) {
      var message = jsonEncode({
        'type': 'play',
        'letter': letter,
      });
      channel.sink.add(message);
      print('빙고 클릭 시 받는 웹소켓 응답입니단 $message');
    } else {
      print('빙고 클릭 했을 때 웹소켓 연결이 안됨 ㅅㄱ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responseData = widget.responseData;

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
                  flex: 3,
                ),
                // Flexible(
                //   flex: 9,
                //   child: Column(
                //     children: [
                //       Flexible(
                //         flex: 1,
                //         child: Center(
                //           child: Container(
                //             width: 200,
                //             height: 90,
                //             decoration: BoxDecoration(
                //               color: Color(0xffcfe4d1),
                //               borderRadius: BorderRadius.circular(50),
                //               border: Border.all(
                //                 color: Colors.black54,
                //                 width: 4,
                //               ),
                //             ),
                //             alignment: Alignment.center,
                //             child: Text(
                //               '이안이',
                //               style: TextStyle(
                //                 color: Colors.black,
                //                 fontFamily: 'Maplestory',
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 40,
                //
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Flexible(
                //         flex: 4,
                //         child: responseData != null
                //             ? buildBingoGrid(responseData)
                //             : Container(color: Colors.red),
                //       ),
                //     ],
                //   ),
                // ),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Flexible(
                  flex: 9,
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
                              color: Colors.black54,
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
                      child: responseData != null
                          ? buildBingoGrid(responseData)
                          : Container(color: Colors.yellow),
                    )
                  ]),
                ),
                Flexible(
                  child: Container(),
                  flex: 3,
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
              top: 100,
              child: ElevatedButton(
                onPressed: () async {
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
              top: 200,
              child: ElevatedButton(
                onPressed: sendLastAudio,
                child: Text('통과'),
              ),
            ),
          ]),
        ));
  }
}
