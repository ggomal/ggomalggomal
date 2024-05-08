import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/screens/kids/bingo.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ggomal/services/socket.dart';

class CreateBingoModal extends StatefulWidget {
  const CreateBingoModal({super.key});

  @override
  State<CreateBingoModal> createState() => _CreateBingoModalState();
}

class _CreateBingoModalState extends State<CreateBingoModal> {
  late final WebSocketChannel channel;
  late StreamController streamController;
  bool isConnected = false;
  BingoScreen bingo = BingoScreen();
  String connectionStatus = '오프라인';
  Color textColor = Colors.transparent;

  final List<String> words = [
    '1음절',
    '2음절',
    '3음절 이상'
  ];
  final List<String> initials = [
    'ㅍ,ㅁ,ㅇ',
    'ㄷ,ㅌ,ㄴ',
    'ㄱ,ㅋ,ㅈ,ㅊ',
    'ㅅ',
    'ㄹ'
  ];
  final List<String> finality = [
    '받침 있는 단어', '받침 없는 단어'
  ];
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

  void connectToWebSocket() async{
    var headers = await SocketDio.getWebSocketHeadersAsync();
    channel = IOWebSocketChannel.connect(
      Uri.parse(SocketDio.getWebSocketUrl()),
      headers: headers,
    );
      streamController = StreamController();
      Stream broadcastStream = streamController.stream.asBroadcastStream();

      broadcastStream.listen((response) {
        print('@@@@@@@ㄹ마ㅜ아리ㅜ미나루ㅏㅣㅁㅇ22@@@@@@@@@@@@@@');
        print('웹소켓 응답 : $response');
        if (response.toString().contains('200')) {
          setState(() {
            connectionStatus = '온라인';
          });
        } else {
          setState(() {
            connectionStatus = '오프라인';
          });
        }
      }, onDone: () {
        print('연결 종료 ');
      }, onError: (error) {
        print('소켓 통신에 실패했습니다. $error');
      });
      channel.sink.add(
          '{"type" : "joinRoom","kidId" : "4"}',
      );
      isConnected = true;
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
    channel.stream.listen((response) {
      print('빙고 만들기 응답: $response');
      var data = jsonDecode(response);
      if (data['action'] == "SET_BINGO_BOARD") {
        print('빙고 응답 성공인듯??');
        channel.sink.add(jsonEncode({"type": "bingoBoardSet"}));
        context.go('/kids/bear/bingo');
      }
    }, onDone: () {
      print('빙고 만들기 모달 연결 종료');
    }, onError: (error) {
      print('빙고 통신 실패 ㅋㅋ $error');
    });

    channel.sink.add(jsonEncode({
      "type" : "setBingoBoard",
      "initial" : _selectedInitials,
      "syllable" : syllableCount,
      "finalityFlag" : finalityFlag
    }));

  }

  @override
  void dispose() {
    channel.sink.close();
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Stack(
      children: [
        Container(
          width: 400,
          height: 650,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey),
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
                          color: connectionStatus == '온라인' ? Colors.green : Colors.grey,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '김이안',
                            style: baseText(20.0, FontWeight.bold),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          connectionStatus.toString(),
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
                                color: value == _selectedWords ? Colors.black : null, fontWeight: FontWeight.bold,
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
                      child: Icon(Icons.arrow_drop_down, size: 40, color: Colors.grey),
                    ),
                    items: initials.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            value,
                            style: TextStyle(
                              color: value == _selectedInitials ? Colors.black : null,
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
                      child: Icon(Icons.arrow_drop_down, size: 40, color: Colors.grey),
                    ),
                    items: finality.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            value,
                            style: TextStyle(
                              color: value == _selectedFinality ? Colors.black : null,
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
              Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0), child: Text('아이가 접속하지 않았습니다', style: TextStyle(color: textColor, fontFamily: 'NanumS', fontSize: 18,)),),
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
                    // onPressed: () {
                    //   if (connectionStatus == '온라인') {
                    //     setBingoBoard();
                    //     context.go('/kids/bear/bingo');
                    //   } else {
                    //     setState(() {
                    //       textColor = Colors.red;
                    //     });
                    //   }
                    // },
                    onPressed: () {
                        // context.go('/kids/bear/bingo');
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
              Navigator.of(context).pop();
            },
            child: Image.asset(
              'assets/images/manager/close_button.png',
              width: 35,
            ),
          ),
        )
      ],
    )
    );
  }
}
