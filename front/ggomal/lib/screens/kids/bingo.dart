// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// main() {
//   // Dart client
//   IO.Socket socket = IO.io('http://localhost:3000');
//   socket.onConnect((_) {
//     print('connect');
//     socket.emit('msg', 'test');
//   });
//   socket.on('event', (data) => print(data));
//   socket.onDisconnect((_) => print('disconnect'));
//   socket.on('fromServer', (_) => print(_));
// }

import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

class BingoScreen extends StatelessWidget {
  const BingoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bear/bingo_bg.png"),
            fit: BoxFit.cover, // 화면에 꽉 차게
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
                  child: Container(
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Column(children: [
                    Flexible(
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 100,
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
                            '아이 이름',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(color: Colors.red),
                      flex: 4,
                    ),
                  ],),
                  flex: 3,
                ),
                Flexible(
                  child: Column(children: [
                    Flexible(
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 100,
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
                              fontSize: 30,
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
                  child: Container(
                  ),
                  flex: 1,
                )
              ],
            ))
          , Positioned(
              left: 0, // 왼쪽 가장자리
              bottom: 0, // 아래쪽 가장자리
              child: Image.asset(
                'assets/images/bear/student.png', // 왼쪽 아래 이미지
                width: 250, // 너비 설정
                height: 250, // 높이 설정
              ),
            ),
            Positioned(
              right: 0, // 오른쪽 가장자리
              bottom: 5, // 아래쪽 가장자리
              child: Image.asset(
                'assets/images/bear/teacher.png', // 오른쪽 아래 이미지
                width: 250, // 너비 설정
                height: 250, // 높이 설정
              ),
            ),]),
        ));
  }
}
