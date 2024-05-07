import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class BearScreen extends StatefulWidget {
  const BearScreen({super.key});

  @override
  State<BearScreen> createState() => _BearScreenState();
}

class _BearScreenState extends State<BearScreen> {
  final player = AudioPlayer();
  late final WebSocketChannel channel;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    player.play(AssetSource('images/bear/audio/bear_welcome.mp3'));
    connectToWebSocket();
  }

  void connectToWebSocket() {
    if (!isConnected) {
      channel = IOWebSocketChannel.connect(
          Uri.parse('wss://k10e206.p.ssafy.io/api/v1/room'),
          headers: {
            "authorization": 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJjZW50ZXJJZCI6Miwicm9sZSI6IktJRCIsIm1lbWJlck5hbWUiOiLrp4jripjslYTsnbQiLCJtZW1iZXJJZCI6NCwic3ViIjoia2lkMSIsImlhdCI6MTcxNDkxMjg4MiwiZXhwIjoxMDE3MTQ5MTI4ODJ9.poP4jnnsdQhINLLD5RM9zDQNFcsJ_LQ57PDqB0exdJ8',
            "name" : "kid"
          });
      channel.stream.listen((response) {
        print('웹소켓 응답 : $response');
        Map<String, dynamic> message = jsonDecode(response);
        String? roomId = message['roomId'];
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
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          player.play(AssetSource('images/bear/audio/window.mp3'));
                        },
                        child: Image.asset('assets/images/bear/window.png'),
                      ),
                      InkWell(
                        onTap: () {
                          player.play(AssetSource('images/bear/audio/mirror.mp3'));
                        },
                        child: Image.asset('assets/images/bear/mirror.png'),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0,0),
                        child: InkWell(
                          onTap: () {
                            player.play(AssetSource('images/bear/audio/chair.mp3'));
                          },
                          child: Image.asset('assets/images/bear/chair1.png'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(280, 0, 0,0),
                        child: InkWell(
                          onTap: () {
                            player.play(AssetSource('images/bear/audio/chair.mp3'));
                          },
                          child: Image.asset('assets/images/bear/chair2.png'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          player.play(AssetSource('images/bear/audio/guitar.mp3'));
                        },
                        child: SizedBox(child: Image.asset('assets/images/bear/guitar.png'), width: 150,),
                      ),
                      InkWell(
                        onTap: () {
                          player.play(AssetSource('images/bear/audio/teacher.mp3'));
                        },
                        child: SizedBox(child: Image.asset('assets/images/bear/teacher.png'), width: 260,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 320,
              left: 160,
              child: InkWell(
                onTap: () {
                  player.play(AssetSource('images/bear/audio/table.mp3'));
                },
                  child: Image.asset('assets/images/bear/table.png', width: 530),
              ),
            ),
            Positioned(
              top: 270,
              left: 360,
              child: InkWell(
                onTap: () {
                  player.play(AssetSource('images/bear/audio/milk.mp3'));
                },
                child: SizedBox(
                  width: 130,
                  child: Image.asset('assets/images/bear/milk.png'),
                ),
              ),
            ),
            Positioned(
              top: 360,
              left: 560,
              child: InkWell(
                onTap: () {
                  player.play(AssetSource('images/bear/audio/pencil.mp3'));
                },
                child: SizedBox(
                  width: 70,
                  child: Image.asset('assets/images/bear/pencil.png'),
                ),
              ),
            ),
            Positioned(
              top: 390,
              left: 380,
              child: InkWell(
                onTap: () {
                  player.play(AssetSource('images/bear/audio/notebook.mp3'));
                },
                child: SizedBox(
                  width: 200,
                  child: Image.asset('assets/images/bear/notebook.png'),
                ),
              ),
            ),
            Positioned(
              top: 350,
              left: 210,
              child: InkWell(
                onTap: () {
                  player.play(AssetSource('images/bear/audio/hat.mp3'));
                },
                child: SizedBox(
                  width: 180,
                  child: Image.asset('assets/images/bear/hat.png'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
