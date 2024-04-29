import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

class BingoScreen extends StatefulWidget {
  const BingoScreen({super.key});

  @override
  State<BingoScreen> createState() => _BingoScreenState();
}

class _BingoScreenState extends State<BingoScreen> {
  // final socketUrl = Uri.parse('wss://k10e206.p.ssafy.io/api/v1/room');
  // final channel = WebSocketChannel.connect(Uri.parse('wss://k10e206.p.ssafy.io/api/v1/room'));
  //
  // @override
  // void initState() {
  //   super.initState();
  //   connectToWebSocket();
  // }
  //
  // void connectToWebSocket() {
  //   try {
  //     channel.stream.listen((message) {
  //       print("소켓 통신 성공~~~!: $message");
  //       // channel.sink.add('소켓 통신~~~!!!');
  //     }, onDone: () {
  //       print('소켓 통신 성공 했다가 닫힐때 나오는 메시지임 ');
  //     }, onError: (error) {
  //       print('소켓 통신에 실패했습니다.');
  //     });
  //     print('WebSocket connection established.');
  //   } catch (e) {
  //     print('소켓 통신 에러날 때 나오는 메시지 $e');
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   channel.sink.close(status.goingAway);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // channel.ready;
    //
    // channel.stream.listen((message) {
    //   channel.sink.add('소켓 통신~~~!!!');
    //   channel.sink.close(status.goingAway);
    // });

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
                  child: Column(
                    children: [
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
                        child: Container(color: Colors.red),
                        flex: 4,
                      ),
                    ],
                  ),
                  flex: 3,
                ),
                Flexible(
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
                      child: Container(color: Colors.yellow),
                      flex: 4,
                    )
                  ]),
                  flex: 3,
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
          ]),
        ));
  }
}
