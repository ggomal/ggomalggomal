import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ManagerBingoModal extends StatefulWidget {
  final Map<String, dynamic> selectData;
  final WebSocketChannel channel;

  const ManagerBingoModal(this.selectData, {super.key, required this.channel});

  @override
  State<ManagerBingoModal> createState() => _ManagerBingoModalState();
}

class _ManagerBingoModalState extends State<ManagerBingoModal> {
  int recordCount = 0;

  @override
  void initState() {
    super.initState();
    recordCount = 0;
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
                          height: 160,
                          child: Center(
                              child: Image(
                            image: NetworkImage(widget.selectData['img']),
                          )),
                        )),
                    Flexible(
                      flex: 4,
                      child: Center(
                          child: Text("${speechData['letter']}",
                              style: mapleText(
                                  100, FontWeight.w700, Colors.black))),
                    ),
                    Flexible(flex: 1, child: Container()),
                  ]),
                ),
                Text("아이의 발음을 듣고 버튼을 눌러주세요",
                    style: mapleText(23, FontWeight.w300, Colors.black54)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            var message = json.encode({
                              "type": "requestVoice",
                              "letter": widget.selectData['letter']
                            });
                            print('통과버튼 누르면 $message');
                            widget.channel.sink.add(message);
                          },
                          child: Image.asset(
                            'assets/images/manager/pass_button.png',
                            height: 80,
                          ),
                        ),
                        Text("통과",
                            style: mapleText(30, FontWeight.w200, Colors.black))
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              recordCount += 1;
                            });
                            print('아이 연습 단어랑 횟수 ${speechData['letter']}, $recordCount');
                          },
                          child: Image.asset(
                            'assets/images/manager/retry_button.png',
                            height: 80,
                          ),
                        ),
                        Text("다시하기",
                            style: mapleText(30, FontWeight.w200, Colors.black))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
