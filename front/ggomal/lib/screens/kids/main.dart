import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/utils/navbar.dart';

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
                      dynamicWidth * 0.3, 30, dynamicWidth * 0.3, 0),
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
                          context.go('/kids/bear');
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
                                return GameDialogUI();
                              });
                          // 모달창 -> 시작하기
                          //context.go('/kids/frog');
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/frog_house.png'),
                          width: dynamicWidth,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.go('/kids/whale');
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
              child: SizedBox(
                child: Image.asset('assets/images/girl.png'),
                width: dynamicWidth * 0.8,
              ),
            ),
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

class GameDialogUI extends StatelessWidget {
  const GameDialogUI({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.6;
    double height = screenSize.height * 0.7;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        // padding: EdgeInsets.all(20),
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/game_modal.png"),
          fit: BoxFit.fill,
        )),
        child: Column(
          children: [
            Flexible(
              flex: 3,
                child: Stack(
                  children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text("개구리 게임"),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle
                          ),
                          child: IconButton(
                            icon: Icon(Icons.close, color: Colors.blue),
                            onPressed: (){},
                          ),
                        )


                  ],
                )),
            Flexible(
              flex: 8,
                child: Container(
              color: Colors.blue,
            )),
          ],
        ),
      ),
    );
  }
}
