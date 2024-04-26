import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ggomal/screens/kids/frog.dart';
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
                flex: 9,
                child: Row(
                  children: [
                    Flexible(flex: 2, child: Container()),
                    Flexible(flex: 8, child: Container(
                      child: LayoutBuilder(builder: (context, constraints){
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.2,
                            vertical: constraints.maxHeight * 0.2
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFAE0CA),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0,3)
                              )]
                            ),
                            child: Center(
                              child: Text("개구리 게임", style: TextStyle(
                                fontFamily: 'MapleStoryBold',
                                fontSize: height * 0.08
                              ),),
                            ),
                          ),
                        );
                      }))),
                    Flexible(flex: 2, child: Container(decoration: BoxDecoration(color: Color(0xFF39855E), shape: BoxShape.circle),child: Container(
                      child: IconButton(
                        iconSize: height * 0.1,
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ),)),
                  ],
                )
            ),
            Flexible(
                flex: 20,
                child: Container(
                  child: Row(
                    children: [
                      Flexible(flex: 1, child: Container()),
                      Flexible(flex: 12, child: Container(child:
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                vertical: constraints.maxHeight * 0.1
                              ),
                              child: Container(child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(flex : 5, child : Container(child : Image.asset("assets/images/frog/mini_frog.png"))),
                                  Flexible(flex : 5, child : Container( child: Column(
                                    children: [
                                      Flexible(flex: 7, child: LayoutBuilder(builder: (context, constraints){
                                        return Container(child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: constraints.maxHeight * 0.1
                                          ),
                                          child: Text("혀를 길게 내밀면 개구리가 간식을 먹어요! 개구리가 배부를 수 있도록 모든 간식을 먹어봅시다!",
                                              style: TextStyle(fontFamily: "MapleStoryBold",fontSize: constraints.maxHeight * 0.12)),
                                        ));
                                      })),
                                      Flexible(flex: 3, child: Container(
                                        child: LayoutBuilder(
                                          builder: (context, constraints){
                                            double buttonPading = constraints.maxWidth * 0.05;
                                            return Container(
                                              child: Center(
                                                child: ElevatedButton(
                                                  onPressed: (){
                                                    context.go('/kids/frog');
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                                    child: Text(
                                                      "시작하기",
                                                      style: TextStyle(
                                                        fontSize: constraints.maxWidth * 0.08, fontFamily: 'MapleStoryBold', color: Color(0xFF003D06)
                                                      ),
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color(0xFFCFE4D1),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(12),
                                                      side: BorderSide(color: Color(0xFF455747), width: 2.0)
                                                    )
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ))
                                    ],
                                  ),)),
                                ],
                              )),
                            );
                          },
                        ),)),
                      Flexible(flex: 1, child: Container()),
                    ],
                  ),
                )),
            Flexible(flex:4 , child: Container(),)
          ],
        ),
      ),
    );
  }
}
