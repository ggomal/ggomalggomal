import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ggomal/widgets/frog_game.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../utils/game_bosang_dialog.dart';
import '../../utils/game_dialog.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double dynamicWidth = MediaQuery.of(context).size.width * 0.23;

    final AudioPlayer player = AudioPlayer();

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/main.png'),
          fit: BoxFit.cover, // 화면에 꽉 차게
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: NavBar(),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      dynamicWidth * 0.3, dynamicWidth*0.3, dynamicWidth * 0.3, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          context.go('/kids/chick');
                          player.play(AssetSource('audio/touch.mp3'));
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/chick_house.png'),
                          width: dynamicWidth,
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          player.play(AssetSource('audio/touch.mp3'));
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return GameDialog(
                                  gameTitle : '곰돌이 게임',
                                  gameDescription: '선생님과 빙고 게임을 즐겨요! \n\n원하는 단어를 말하고, 먼저 빙고를 완성하는 사람이 승리합니다!',
                                  gameImage: 'assets/images/bear/bear_game_modal.png',
                                  gamePath: '/kids/bear',
                                );
                              });
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/bear_house.png'),
                          width: dynamicWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Frog
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          player.play(AssetSource('audio/touch.mp3'));
                          // showDialog(
                          //     context: context,
                          //     builder: (builder) {
                          //       return GameDialog(
                          //         gameTitle : '개구리 게임',
                          //         gameDescription: '혀를 길게 내밀면 개구리가 파리를 먹어요! \n\n개구리의 신호에 맞춰서 혀를 내밀어 봅시다 !',
                          //         gameImage: 'assets/images/frog/mini_frog.png',
                          //         gamePath: '/kids/frog',
                          //       );
                          //     });
                          context.go('/kids/frog');
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/frog_house.png'),
                          width: dynamicWidth,
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          player.play(AssetSource('audio/touch.mp3'));
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return GameDialog(
                                  gameTitle : '고래 게임',
                                  gameDescription: '목소리를 통해 고래를 이동시켜요. \n\n고래가 배부를 수 있도록 물고기를 먹어주세요!',
                                  gameImage: 'assets/images/whale/whale_game_modal.png',
                                  gamePath: '/kids/whale',
                                );
                              });
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/whale_house.png'),
                          width: dynamicWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  player.play(AssetSource('audio/touch.mp3'));
                  context.go('/kids/home');
                },
                child: SizedBox(
                  width: dynamicWidth * 0.8,
                  child: Image.asset('assets/images/girl.png'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


