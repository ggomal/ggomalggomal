import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ggomal/services/socket.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:ggomal/login_storage.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/bingo_dio.dart';
import 'package:go_router/go_router.dart';

class BearScreen extends StatefulWidget {
  const BearScreen({super.key});

  @override
  State<BearScreen> createState() => _BearScreenState();
}

class KidBingoModal extends StatefulWidget {
  final Map<String, dynamic> selectData;

  const KidBingoModal(this.selectData, {super.key});

  @override
  State<KidBingoModal> createState() => _KidBingoModalState();
}

class _KidBingoModalState extends State<KidBingoModal> {
  String? currentFilePath;
  int recordCount = 0;
  final recorder = FlutterSoundRecorder();
  String filePath = '';


  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  Future initRecorder() async {
    var status = await Permission.speech.status;
    if (!status.isGranted) {
      print('권한 허용안됨');
      throw '마이크 권한이 허용되지 않았습니다';
    }
    await recorder.openRecorder();
  }

  Future<void> record() async {
    Directory tempDir = await getTemporaryDirectory();
    currentFilePath = '${tempDir.path}/audio_$recordCount.wav';
    await recorder.startRecorder(
        toFile: currentFilePath, codec: Codec.pcm16WAV);
    print('녹음 시작: $currentFilePath');
  }

  Future<void> stop() async {
    await recorder.stopRecorder();
    setState(() {
      recordCount++;
    });
    print('녹음한 횟수 $recordCount');
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> speechData = widget.selectData;
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.6;
    double height = screenSize.height * 0.7;

    return Dialog(
      child: Stack(
        children: [
          Image.asset("assets/images/chick/chick_modal.png",
              width: width, height: height, fit: BoxFit.fill),

          Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  child: Row(children: [
                    Flexible(flex: 1, child: Container()),
                    Flexible(
                        flex: 4,
                        child: SizedBox(
                          height: 300,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: Center(
                                child: Image(
                              image: NetworkImage(widget.selectData['img']),
                            )),
                          ),
                        )),
                    Flexible(
                      flex: 4,
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Text("${speechData['letter']}",
                            style:
                                mapleText(180, FontWeight.w700, Colors.black)),
                      )),
                    ),
                    Flexible(flex: 1, child: Container()),
                  ]),
                ),
                Text("단어를 듣고 따라 말해봅시다~!",
                    style: mapleText(50, FontWeight.w300, Colors.black54)),
                ElevatedButton(
                  onPressed: () async {
                    if (recorder.isRecording) {
                      await stop();
                    } else {
                      await record();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 50,
                    ),
                    backgroundColor: Color(0xFFFFFAAC),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(recorder.isRecording ? '끝내기' : '말하기',
                      style: mapleText(40, FontWeight.w700, Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BearScreenState extends State<BearScreen> {
  final AudioPlayer player = AudioPlayer();
  late final WebSocketChannel channel;
  bool isConnected = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  List<List<Map<String, dynamic>>> bingoBoardData = [];
  late final Stream broadcastStream;
  StreamSubscription? subscription;
  bool showBingo = false;
  int recordCount = 0;
  late String currentFilePath;
  final LoginStorage storage = LoginStorage();
  String currentLetter = '';
  int gameNum = 0;
  int turn = 1;

  @override
  void initState() {
    super.initState();
    initRecorder();
    player.play(AssetSource('images/bear/audio/bear_welcome.mp3'));
    connectToWebSocket();
  }

  final recorder = FlutterSoundRecorder();

  void connectToWebSocket() async {
    var headers = await SocketDio.getWebSocketHeadersAsync();
    if (!isConnected) {
      channel = IOWebSocketChannel.connect(
        Uri.parse(SocketDio.getWebSocketUrl()),
        headers: headers,
      );

      broadcastStream = channel.stream.asBroadcastStream();
      broadcastStream.listen((response) {
        print('웹소켓 응답 : $response');
        Map<String, dynamic> message = jsonDecode(response);
        switch (message['action']) {
          case 'SET_BINGO_BOARD':
            gameNum = message['gameNum'];
            var boardData = message['bingoBoard']['board'] as List;
            List<List<Map<String, dynamic>>> formattedData =
                boardData.map((row) {
              return (row as List).map((item) {
                var mapItem = item as Map<String, dynamic>;
                mapItem['isSelected'] = false;
                return mapItem;
              }).toList();
            }).toList();

            setState(() {
              bingoBoardData = formattedData;
            });
            print('뭘로들어오려나 두근두근 ㅎㅎ');

            subscription?.cancel();
            subscription = null;
            showBingo = true;
            break;
          case 'FIND_LETTER':
            print('빙고판 데이터 출력 $bingoBoardData');
            setState(() {
              currentLetter = message['letter'];
            });
            var foundItem = bingoBoardData.expand((e) => e).firstWhere(
                  (item) => item['letter'] == message['letter'],
                  orElse: () => {'soundUrl': null},
                );
            if (foundItem != null && foundItem['soundUrl'] != null) {
              player.play(UrlSource(Uri.encodeFull(foundItem['soundUrl'])));
              StreamSubscription? completionSubscription;
              completionSubscription = player.onPlayerComplete.listen((event) {
                player
                    .play(AssetSource('audio/bear/find_letter.mp3'))
                    .then((_) {
                  completionSubscription?.cancel();
                });
              });
            } else {
              print('찾은 소리 항목이 없음 ');
            }
            break;

          case 'REQ_VOICE':
            sendLastAudio(message['letter']);
            break;
            // if (turn == 1) {
            //   setState(() {
            //     turn = 2;
            //   });
            // } else if (turn == 2) {
            //   setState(() {
            //     turn == 1;
            //   });
            // }

          case 'SAY_AGAIN':
            player.play(AssetSource('audio/bear/say_again.mp3'));
            break;

          case 'MARKING_BINGO':
            print('마킹빙고 응답확인');
            print('순서 확인 $turn');
            Navigator.pop(context);

            String markedLetter = message['letter'];
            setState(() {
              for (var row in bingoBoardData) {
                for (var item in row) {
                  if (item['letter'] == markedLetter) {
                    item['isSelected'] = true;
                  }
                }
              }
            });


            // if (turn == 1) {
            //   setState(() {
            //     turn = 2;
            //   });
            // } else if (turn == 2) {
            //   setState(() {
            //     turn == 1;
            //   });
            // }

            if (turn == 1) {
              turn = 2;
            } else if (turn == 2) {
              turn = 1;
            }
            print('다음 순서 확인 $turn');
            break;

          case 'GAME_OVER':
            if (message['winner'] == 'KID') {
              KidWinModal();
            } else if (message['winner'] == 'TEACHER') {
              KidLoseModal();
            } else {
              print('빙고 끝났는데 이긴 사람 이상함 ㅠㅠ');
            }
            break;
        }
      }, onDone: () {
        print('연결 종료 ');
      }, onError: (error) {
        print('소켓 통신에 실패했습니다. $error');
      });
      channel.sink.add('{"type" : "createRoom"}');
      isConnected = true;
    }
  }

  void BingoSelect(Map<String, dynamic> thing) async {

    player.play(UrlSource(Uri.encodeFull(thing['soundUrl'])));
    showDialog(
      context: context,
      builder: (BuildContext context) => KidBingoModal({
        "wordId": "1",
        "pronunciation": thing['pronunciation'],
        "letter": thing['letter'],
        "img": thing['letterImgUrl'],
      }),
    );
  }

  Future<void> sendWebSocketMessage(dynamic thing) async {
    if (channel != null && isConnected) {
      var message = jsonEncode({
        'type': 'play',
        'letter': thing['letter'],
      });
      channel.sink.add(message);
      print('빙고 클릭 시 받는 웹소켓 응답입니단 그리고 이건 곰 집 페이지 $message');
    } else {
      print('빙고 클릭 했을 때 웹소켓 연결이 안됨 ㅅㄱ');
    }
  }

  void KidWinModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Stack(children: [
              Image.asset('assets/images/bear/kid_win.png'),
              InkWell(
                  onTap: () {
                    context.go('/kids');
                  },
                  child: Positioned(
                      left: 500,
                      right: 0,
                      bottom: 100,
                      child: Image.asset('assets/images/bear/main_button.png')))
            ]),
          );
        });
  }

  void KidLoseModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Stack(children: [
              Image.asset('assets/images/bear/kid_lose.png'),
              InkWell(
                  onTap: () {
                    context.go('/kids');
                  },
                  child: Positioned(
                      left: 500,
                      right: 0,
                      bottom: 100,
                      child: Image.asset('assets/images/bear/main_button.png')))
            ]),
          );
        });
  }

  Future initRecorder() async {
    var status = await Permission.speech.status;
    if (!status.isGranted) {
      status = await Permission.speech.request();
      print('권한 허용안됨');
      throw '마이크 권한이 허용되지 않았습니다';
    }
    await recorder.openRecorder();
  }

  Future<void> stop() async {
    await recorder.stopRecorder();
    if (currentFilePath != null) {
      setState(() {
        recordCount++;
      });
    }
    print('녹음종료됨');
  }

  Future<void> sendLastAudio(String word) async {
    if (currentFilePath == null) {
      print('녹음 파일이 아직 준비되지 않았습니다.');
      return;
    }

    var foundItem = bingoBoardData.expand((e) => e).firstWhere(
          (item) => item['letter'] == word,
          orElse: () => {},
        );
    print('지금 녹음 파일 경로 $currentFilePath');
    if (currentFilePath.isNotEmpty) {
      final response = await sendBingoAudio(currentFilePath, word,
          foundItem['wordId'], recordCount.toString(), gameNum);
      print('녹음 데이터 보내고 들어오는 응답 확인하는중 $response');
      if (response.statusCode == 200) {
        print('녹음 전송됨');
      } else {
        var httpResponse = await http.Response.fromStream(response);
        print('녹음 전송 실패: ${httpResponse.body}');
      }
    }
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
        var cell = flatList[index];
        return InkWell(
            onTap: () {
              BingoSelect(cell);
              sendWebSocketMessage(cell);
              setState(() {
                recordCount = 0;
                currentLetter = '';
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(cell['letterImgUrl'] ??
                          'assets/images/placeholder.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Text(cell['letter'],
                      style: mapleText(40, FontWeight.bold, Colors.black)),
                ),
                if (cell['isSelected'])
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red,
                        width: 40,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
              ],
            ));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }

  Widget BearWidget() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bear/bear_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: NavBar(),
        body: Stack(
          children: [
            Column(
              children: [
                Flexible(flex:1, child: Container()),
                Flexible(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          player.play(
                              AssetSource('images/bear/audio/window.mp3'));
                        },
                        child: Image.asset('assets/images/bear/window.png'),
                      ),
                      InkWell(
                        onTap: () {
                          player.play(
                              AssetSource('images/bear/audio/mirror.mp3'));
                        },
                        child: Image.asset('assets/images/bear/mirror.png'),
                      ),
                    ],
                  ),
                ),
                Flexible(flex:1, child: Container()),
                Flexible(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: InkWell(
                          onTap: () {
                            player.play(
                                AssetSource('images/bear/audio/chair.mp3'));
                          },
                          child: Image.asset('assets/images/bear/chair1.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(400, 0, 0, 0),
                        child: InkWell(
                          onTap: () {
                            player.play(
                                AssetSource('images/bear/audio/chair.mp3'));
                          },
                          child: Image.asset('assets/images/bear/chair2.png',),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          player.play(
                              AssetSource('images/bear/audio/guitar.mp3'));
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/bear/guitar.png'),
                          height: 400,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                        child: InkWell(
                          onTap: () {
                            player.play(
                                AssetSource('images/bear/audio/teacher.mp3'));
                          },
                          child: SizedBox(
                            child: Image.asset('assets/images/bear/teacher.png'),
                            width: 350,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 600,
              left: 160,
              child: InkWell(
                onTap: () {
                  player.play(AssetSource('images/bear/audio/table.mp3'));
                },
                child: Image.asset('assets/images/bear/table.png', width: 800),
              ),
            ),
            Positioned(
              top: 550,
              left: 400,
              child: InkWell(
                onTap: () {
                  player.play(AssetSource('images/bear/audio/milk.mp3'));
                },
                child: SizedBox(
                  width: 200,
                  child: Image.asset('assets/images/bear/milk.png'),
                ),
              ),
            ),
            Positioned(
              top: 630,
              left: 730,
              child: InkWell(
                onTap: () {
                  player.play(AssetSource('images/bear/audio/pencil.mp3'));
                },
                child: SizedBox(
                  width: 150,
                  child: Image.asset('assets/images/bear/pencil.png',),
                ),
              ),
            ),
            Positioned(
              top: 720,
              left: 530,
              child: InkWell(
                onTap: () {
                  player.play(AssetSource('images/bear/audio/notebook.mp3'));
                },
                child: SizedBox(
                  width: 250,
                  child: Image.asset('assets/images/bear/notebook.png'),
                ),
              ),
            ),
            Positioned(
              top: 700,
              left: 300,
              child: InkWell(
                onTap: () {
                  player.play(AssetSource('images/bear/audio/hat.mp3'));
                },
                child: SizedBox(
                  width: 200,
                  child: Image.asset('assets/images/bear/hat.png'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget BingoWidget() {
    return FutureBuilder(
      future: storage.getRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == 'KID') {}
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
                  if (turn == 1)
                    Positioned(
                      bottom: 400,
                      left: 100,
                      child: Container(
                        color: Colors.white,
                        width: 300,
                        height: 100,
                        child: Text('내 차례', style: mapleText(50, FontWeight.bold, Colors.black),),
                      ),
                    ),
                  if (turn == 2)
                    Positioned(
                      bottom: 400,
                      right: 100,
                      child: Container(
                        color: Colors.blue,
                        width: 300,
                        height: 100,
                        child: Text('선생님 차례', style: mapleText(50, FontWeight.bold, Colors.black),),
                      ),
                    ),
                  Container(
                      child: Row(
                    children: [
                      Flexible(
                        child: Container(),
                        flex: 1,
                      ),
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 50, 0, 30),
                          child: bingoBoardData != null
                              ? buildBingoGrid(bingoBoardData)
                              : Container(color: Colors.yellow),
                        ),
                      ),
                      Flexible(
                        child: Container(),
                        flex: 1,
                      )
                    ],
                  )),
                  Positioned(
                    left: 30,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/bear/student.png',
                      width: 300,
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: 5,
                    child: Image.asset(
                      'assets/images/bear/teacher.png',
                      width: 300,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 30,
                    child: currentLetter.isNotEmpty
                        ? Text(
                            '$currentLetter 단어 카드를 눌러봐',
                            style: mapleText(50, FontWeight.bold, Colors.black),
                          )
                        : SizedBox.shrink(),
                  ),
                ]),
              ));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: Colors.grey,
            body: Stack(
              children: [
                if (showBingo) BingoWidget(),
                if (!showBingo) BearWidget(),
              ],
            )));
  }
}
