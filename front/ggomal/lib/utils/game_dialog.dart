import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';

class GameDialog extends StatelessWidget {
  final String gameTitle;
  final String gameDescription;
  final String gameImage;
  final String gamePath;

  const GameDialog({
    super.key,
    required this.gameTitle,
    required this.gameDescription,
    required this.gameImage,
    required this.gamePath,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.6;
    double height = screenSize.height * 0.7;
    final AudioPlayer player = AudioPlayer();
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
                                child: Text(gameTitle, style: TextStyle(
                                    fontFamily: 'Maplestory',
                                    fontWeight: FontWeight.bold,
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
                            player.play(AssetSource('audio/touch.mp3'));
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
                              vertical: constraints.maxHeight * 0.1,
                              horizontal: 10,
                            ),
                            child: Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(flex : 5, child : Container(child : Image.asset(gameImage))),
                                Flexible(flex : 5, child : Container( child: Column(
                                  children: [
                                    Flexible(flex: 7, child: LayoutBuilder(builder: (context, constraints){
                                      return Container(child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: constraints.maxHeight * 0.1
                                        ),
                                        child: Text(gameDescription,
                                            style: TextStyle(
                                                fontFamily: 'Maplestory',
                                                fontWeight: FontWeight.bold,
                                                fontSize: constraints.maxHeight * 0.12)),
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
                                                  print("===============");
                                                  print("게임모달창 이동!!!");
                                                  print("===============");
                                                  player.play(AssetSource('audio/touch.mp3'));
                                                  context.go(gamePath);
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                                  child: Text(
                                                    "시작하기",
                                                    style: TextStyle(
                                                        fontSize: constraints.maxWidth * 0.08, fontFamily: 'Maplestory',
                                                        fontWeight: FontWeight.bold, color: Color(0xFF003D06)
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