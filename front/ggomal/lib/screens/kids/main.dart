import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ggomal/screens/kids/frog.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/utils/navbar.dart';

import '../../utils/game_bosang_dialog.dart';
import '../../utils/game_dialog.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double dynamicWidth = MediaQuery.of(context).size.width * 0.23;

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
                        onTap: () {
                          context.go('/kids/chick');
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/chick_house.png'),
                          width: dynamicWidth,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return GameDialog(
                                  gameTitle : '곰돌이 게임',
                                  gameDescription: '선생님과 빙고 게임을 즐겨요! 원하는 단어를 말하고, 먼저 빙고를 완성하는 사람이 승리합니다!',
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
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return GameDialog(
                                  gameTitle : '개구리 게임',
                                  gameDescription: '혀를 길게 내밀면 개구리가 간식을 먹어요! 개구리가 배부를 수 있도록 모든 간식을 먹어봅시다!',
                                  gameImage: 'assets/images/frog/mini_frog.png',
                                  gamePath: '/kids/frog',
                                );
                              });
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/frog_house.png'),
                          width: dynamicWidth,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return GameDialog(
                                  gameTitle : '고래 게임',
                                  gameDescription: '음성을 통해 고래를 이동시켜요. 고래가 배부를 수 있도록 모든 먹이를 먹어주세요!',
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
                onTap: () {
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


