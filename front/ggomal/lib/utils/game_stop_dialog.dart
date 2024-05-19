import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
class GameStopDialog extends StatelessWidget {
  final String continuePage;

  const GameStopDialog({
    required this.continuePage,
    super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.6;
    double height = screenSize.height * 0.7;
    final AudioPlayer player = AudioPlayer();
    return Dialog(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/game_stop_modal.png"),
                fit: BoxFit.fill
            )
        ),
        child: Column(
          children: [
            Expanded(flex: 6, child: Container(),),
            Expanded(flex: 4, child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: (){
                      player.play(AssetSource('audio/touch.mp3'));
                      context.go(continuePage);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10
                      ),
                      child: Text(
                        "계속하기",
                        style: TextStyle(
                            fontSize: 35, fontFamily: 'Maplestory',
                            fontWeight: FontWeight.bold, color: Colors.black
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCFE4D1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(color: Colors.black, width: 4.0)
                        )
                    ),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: (){
                      player.play(AssetSource('audio/touch.mp3'));
                      context.go("/kids");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10
                      ),
                      child: Text(
                        "마을가기",
                        style: TextStyle(
                            fontSize: 35, fontFamily: 'Maplestory',
                            fontWeight: FontWeight.bold, color: Colors.black
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD2D2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(color: Colors.black, width: 4.0)
                        )
                    ),
                  ),
                )
              ],
            ),),
            Expanded(flex: 1, child: Container())
          ],
        ),
      ),
    );
  }
}