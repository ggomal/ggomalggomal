import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ggomal/widgets/manager_bingo.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ggomal/services/socket.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ggomal/widgets/navbar_teacher.dart';
import 'package:http/http.dart' as http;
import 'package:ggomal/login_storage.dart';
import 'package:ggomal/constants.dart';
import 'package:go_router/go_router.dart';

class CreateBingo extends StatefulWidget {
  final String? name;
  final int? memberId;

  const CreateBingo({
    super.key,
    required this.name,
    required this.memberId,
  });

  @override
  State<CreateBingo> createState() => _CreateBingoModalState();
}

class _CreateBingoModalState extends State<CreateBingo> {
  late final WebSocketChannel channel;
  late final Stream broadcastStream;
  late StreamController streamController;
  bool isConnected = false;

  // String connectionStatus = '오프라인';
  Color textColor = Colors.transparent;
  List<List<Map<String, dynamic>>> bingoBoardData = [];
  bool showBingo = false;
  int recordCount = 0;
  late String currentFilePath;
  final LoginStorage storage = LoginStorage();

  final List<String> words = ['2음절', '3음절 이상'];
  final List<String> initials = ['ㅍ,ㅁ,ㅇ', 'ㄷ,ㅌ,ㄴ', 'ㄱ,ㅋ,ㅈ,ㅊ', 'ㅅ', 'ㄹ'];
  final List<String> finality = ['받침 있는 단어', '받침 없는 단어'];
  String? _selectedInitials;
  String? _selectedWords;
  String? _selectedFinality;

  TextStyle baseText(double size, FontWeight weight) {
    return TextStyle(
      fontFamily: 'NanumS',
      fontWeight: weight,
      fontSize: size,
      color: Colors.black,
    );
  }

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
    _selectedWords = words.first;
    _selectedInitials = initials.first;
    _selectedFinality = finality.first;
  }

  void connectToWebSocket() async {
    var selectKidId = widget.memberId;
    var headers = await SocketDio.getWebSocketHeadersAsync();
    channel = IOWebSocketChannel.connect(
      Uri.parse(SocketDio.getWebSocketUrl()),
      headers: headers,
    );
    channel.sink.add(
      '{"type" : "isOnlineKidId","kidId" : "$selectKidId"}',
    );

    broadcastStream = channel.stream.asBroadcastStream();

    broadcastStream.listen((response) {
      print('빙고 만드는페이지에서 들어오는 수신 찍어보기 $response');
      Map<String, dynamic> message = jsonDecode(response);
      switch (message['action']) {
        case 'KID_ONLINE':
          print('키즈 접속중인지 들어오는지 보기');

          if (message['isOnline'] == true) {
            setState(() {
              isConnected = true;
            });
          } else if (message['isOnline'] == false) {
            setState(() {
              isConnected = false;
            });
          }
          break;
        case 'JOIN_ROOM':
          setState(() => isConnected = true);
          break;
        case 'EVALUATION':
          print('평가하라는 요청 들어오긴 들어와씀');
          BingoSelect(message['letter']);
          break;
        case 'MARKING_BINGO':
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
        case 'GAME_OVER':
          if (message['winner'] == 'KID') {
            TeacherLoseModal();
          } else if (message['winner'] == 'TEACHER') {
            TeacherWinModal();
          } else {
            print('빙고 끝났는데 이긴 사람 이상함 ㅠㅠ');
          }
      }
    }, onDone: () {
      print('연결 종료 ');
    }, onError: (error) {
      print('소켓 통신에 실패했습니다. $error');
    });

    channel.sink.add(
      '{"type" : "joinRoom","kidId" : "$selectKidId"}',
    );
  }

  void TeacherWinModal() {
    var selectKidId = widget.memberId;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(children: [
              Image.asset('assets/images/bear/teacher_win.png'),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: InkWell(
                    onTap: () {
                      context.go('/manager/bingo/$selectKidId');
                    },
                    child: Image.asset('assets/images/bear/info_button.png')),
              )
            ]),
          );
        });
  }

  void TeacherLoseModal() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(children: [
              Image.asset('assets/images/bear/teacher_lose.png'),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: InkWell(
                    onTap: () {
                      context.go('/manager/kids');
                    },
                    child: Image.asset('assets/images/bear/info_button.png')),
              )
            ]),
          );
        });
  }

  void setBingoBoard() {
    int syllableCount = 1;
    bool finalityFlag = true;

    switch (_selectedWords) {
      case '1음절':
        syllableCount = 1;
        break;
      case '2음절':
        syllableCount = 2;
        break;
      case '3음절 이상':
        syllableCount = 3;
        break;
      default:
        break;
    }
    if (_selectedFinality == '받침 있는 단어') {
      finalityFlag = true;
    } else if (_selectedFinality == '받침 없는 단어') {
      finalityFlag = false;
    }

    print('빙고 보내는 데이터 $_selectedInitials, $syllableCount, $finalityFlag');
    broadcastStream.listen((response) {
      var data = jsonDecode(response);
      if (data['action'] == "SET_BINGO_BOARD") {
        var boardData = data['bingoBoard']['board'] as List;
        List<List<Map<String, dynamic>>> formattedData = boardData.map((row) {
          return (row as List).map((item) {
            var mapItem = item as Map<String, dynamic>;
            mapItem['isSelected'] = false;
            return mapItem;
          }).toList();
        }).toList();
        print('formatdata 어케 출력되는지 보자 $formattedData');
        setState(() {
          bingoBoardData = formattedData;
        });
        showBingo = true;
      }
    }, onDone: () {
      print('빙고 만들기 모달 연결 종료');
    }, onError: (error) {
      print('빙고 통신 실패 ㅋㅋ $error');
    });

    channel.sink.add(jsonEncode({
      "type": "setBingoBoard",
      "initial": _selectedInitials,
      "syllable": syllableCount,
      "finalityFlag": finalityFlag
    }));
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

  void BingoSelect(String letter) {
    print('선택된 레터: $letter');
    var foundItem = bingoBoardData.expand((e) => e).firstWhere(
          (item) => item['letter'] == letter,
          orElse: () => {},
        );
    print('찾은 아이템: $foundItem');
    if (foundItem.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => ManagerBingoModal({
          "letter": foundItem['letter'],
          "pronunciation": foundItem['pronunciation'],
          "img": foundItem['letterImgUrl'],
          "sound": foundItem['soundUrl'],
          "id": foundItem['id'],
        }, channel: channel),
      );
    } else {
      print('해당 레터에 대한 정보를 찾을 수 없습니다.');
    }
  }

  Future<void> sendWebSocketMessage(String letter) async {
    if (channel != null && isConnected) {
      var message = jsonEncode({
        'type': 'play',
        'letter': letter,
      });
      channel.sink.add(message);
      print('빙고 클릭 시 받는 웹소켓 응답입니다 선생님 페이진 $message');
    } else {
      print('빙고 클릭 했을 때 웹소켓 연결이 안됨 ㅅㄱ');
    }
  }

  void ManagerSelect(Map<String, dynamic> thing) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ManagerBingoModal(
        {
          "id": thing['id'],
          "pronunciation": thing['pronunciation'],
          "letter": thing['letter'],
          "img": thing['letterImgUrl'],
        },
        channel: channel,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget CreateBingoWidget() {
    return Stack(
      children: [
        Container(
          width: 400,
          height: 650,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(40, 40, 0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '아이 현황',
                    style: baseText(25, FontWeight.w900),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Icon(
                          Icons.circle,
                          size: 18,
                          color:
                              isConnected == true ? Colors.green : Colors.grey,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${widget.name}',
                            style: baseText(20.0, FontWeight.bold),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          isConnected == true ? '온라인' : '오프라인',
                          style: baseText(
                            17,
                            FontWeight.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 50, 0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '단어 묶음 선택',
                    style: baseText(25, FontWeight.w900),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 0, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '음절',
                    style: baseText(20, FontWeight.normal),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedWords,
                      isExpanded: true,
                      style: TextStyle(
                        fontFamily: 'NanumS',
                        fontSize: 20,
                        color: Color(0xFF767676),
                      ),
                      underline: SizedBox.shrink(),
                      icon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      items:
                          words.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              value,
                              style: TextStyle(
                                color: value == _selectedWords
                                    ? Colors.black
                                    : null,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedWords = newValue;
                        });
                      },
                      itemHeight: null,
                      dropdownColor: Colors.white,
                      menuMaxHeight: 160,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 0, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '초성',
                    style: baseText(20, FontWeight.normal),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedInitials,
                    isExpanded: true,
                    style: TextStyle(
                      fontFamily: 'NanumS',
                      fontSize: 20,
                      color: Color(0xFF767676),
                    ),
                    underline: SizedBox.shrink(),
                    icon: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.arrow_drop_down,
                          size: 40, color: Colors.grey),
                    ),
                    items:
                        initials.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            value,
                            style: TextStyle(
                              color: value == _selectedInitials
                                  ? Colors.black
                                  : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedInitials = newValue;
                      });
                    },
                    itemHeight: null,
                    dropdownColor: Colors.white,
                    menuMaxHeight: 160,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 0, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '종성 유무',
                    style: baseText(20, FontWeight.normal),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedFinality,
                    isExpanded: true,
                    style: TextStyle(
                      fontFamily: 'NanumS',
                      fontSize: 20,
                      color: Color(0xFF767676),
                    ),
                    underline: SizedBox.shrink(),
                    icon: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.arrow_drop_down,
                          size: 40, color: Colors.grey),
                    ),
                    items:
                        finality.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            value,
                            style: TextStyle(
                              color: value == _selectedFinality
                                  ? Colors.black
                                  : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFinality = newValue;
                      });
                    },
                    itemHeight: null,
                    dropdownColor: Colors.white,
                    menuMaxHeight: 160,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Text('아이가 접속하지 않았습니다',
                    style: TextStyle(
                      color: textColor,
                      fontFamily: 'NanumS',
                      fontSize: 18,
                    )),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFAA8D),
                      foregroundColor: Color(0xffFF5B20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setBingoBoard();
                    },
                    child: Text(
                      '시작하기',
                      style: baseText(20, FontWeight.bold),
                    ),
                  ))
            ],
          ),
        ),
        Positioned(
          top: 15,
          right: 15,
          child: GestureDetector(
            onTap: () {
              context.go('/manager/kids');
            },
            child: Image.asset(
              'assets/images/manager/close_button.png',
              width: 35,
            ),
          ),
        )
      ],
    );
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
              // BingoSelect(cell['letter']);
              sendWebSocketMessage(cell['letter']);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black54, width: 2),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 35),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(cell['letterImgUrl'] ??
                              'assets/images/placeholder.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Text(cell['letter'],
                      style: mapleText(35, FontWeight.bold, Colors.black)),
                ),
                if (cell['isSelected'])
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red,
                        width: 25,
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
  Widget BingoWidget() {
    return FutureBuilder(
      future: storage.getRole(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
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
              appBar: NavBarTeacher(),
              body: Stack(children: [
                Container(
                    child: Row(
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 3,
                    ),
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: bingoBoardData != null
                            ? buildBingoGrid(bingoBoardData)
                            : Container(color: Colors.yellow),
                      ),
                    ),
                    Flexible(
                      child: Container(),
                      flex: 3,
                    )
                  ],
                )),
                Positioned(
                  left: 30,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/bear/student.png',
                    width: 230,
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 5,
                  child: Image.asset(
                    'assets/images/bear/teacher.png',
                    width: 230,
                  ),
                ),
              ]),
            ));
        // } else {
        //   return CircularProgressIndicator();
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: Color(0xffE4E4E4),
            body: Stack(
              children: [
                if (showBingo) BingoWidget(),
                if (!showBingo) Align(alignment: Alignment.center,child: CreateBingoWidget()),
              ],
            )));
  }
}
