import 'package:flutter/material.dart';
import 'package:ggomal/services/chick_dio.dart';
import 'package:ggomal/utils/game_bosang_dialog.dart';
import 'package:ggomal/widgets/chick_speech.dart';
import 'package:ggomal/constants.dart';
import 'package:audioplayers/audioplayers.dart';

class PizzaPlate extends StatefulWidget {
  const PizzaPlate({super.key});

  @override
  State<PizzaPlate> createState() => _PizzaPlateState();
}

class _PizzaPlateState extends State<PizzaPlate> {
  final AudioPlayer player = AudioPlayer();
  int toppingIndex = 0;

  List<Map<String, dynamic>> pizzaThingList = [
    {'img': 1, 'name': '햄'},
    {'img': 2, 'name': '피망'},
    {'img': 3, 'name': '고기'},
    {'img': 4, 'name': '버섯'},
    {'img': 5, 'name': '토마토'},
    {'img': 6, 'name': '올리브'},
  ];

  List<Map<String, dynamic>> toppings = [
    {'img': 0, 'top': 100.0, 'left': 110.0, 'isVisible': true},
    {'img': 0, 'top': 200.0, 'left': 230.0, 'isVisible': true},
    {'img': 0, 'top': 110.0, 'left': 305.0, 'isVisible': true},
    {'img': 0, 'top': 80.0, 'left': 160.0, 'isVisible': true},
    {'img': 0, 'top': 140.0, 'left': 80.0, 'isVisible': true},
    {'img': 0, 'top': 220.0, 'left': 150.0, 'isVisible': true},
    {'img': 0, 'top': 160.0, 'left': 310.0, 'isVisible': true},
    {'img': 0, 'top': 235.0, 'left': 195.0, 'isVisible': true},
    {'img': 0, 'top': 120.0, 'left': 170.0, 'isVisible': true},
    {'img': 0, 'top': 145.0, 'left': 215.0, 'isVisible': true},
    {'img': 0, 'top': 210.0, 'left': 105.0, 'isVisible': true},
    {'img': 0, 'top': 215.0, 'left': 280.0, 'isVisible': true},
    {'img': 0, 'top': 90.0, 'left': 260.0, 'isVisible': true},
    {'img': 0, 'top': 180.0, 'left': 70.0, 'isVisible': true},
    {'img': 0, 'top': 180.0, 'left': 170.0, 'isVisible': true},
    {'img': 0, 'top': 100.0, 'left': 210.0, 'isVisible': true},
    {'img': 0, 'top': 150.0, 'left': 120.0, 'isVisible': true},
    {'img': 0, 'top': 160.0, 'left': 260.0, 'isVisible': true},
  ];

  void handleTopping(Map<String, dynamic> thing) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ChickSpeechModal({
        "gameNum": 1,
        "game": "pizza",
        "name": thing['name'],
        "img": thing['img'],
        "ending": "올려줘"
      }),
    ).then((value) => {
          if (value)
            {
              setState(() {
                for (int i = 0; i < 6; i++) {
                  toppings[toppingIndex]['img'] = thing['img'];
                  toppingIndex += 1;
                }
              }),
              if (toppingIndex == 18)
                {
                  Future.delayed(Duration(milliseconds: 1000)).then((value) {
                    chickReward(1, 2);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => GameContinueDialog(
                          continuePage: '/chick/pizza', count: 2),
                    );
                  })
                }
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = screenSize(context).width;
    double height = screenSize(context).height;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 5,
          child: Stack(
            children: [
              Image.asset(
                width: width * 0.35,
                height: height * 0.7,
                'assets/images/chick/pizza_dough.png',
              ),
              ...toppings.map(
                (e) => e['img'] != 0
                    ? Positioned(
                        top: e['top'] as double,
                        left: e['left'] as double,
                        child: Image.asset(
                          "assets/images/chick/pizza_thing_${e['img']}.png",
                          width: width * 0.03,
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
        Flexible(
            flex: 3,
            child: Stack(
              children: [
                Image.asset(
                  width: width * 0.3,
                  height: height * 0.65,
                  'assets/images/chick/pizza_plate.png',
                ),
                Container(
                  width: width * 0.3,
                  height: height * 0.65,
                  padding: const EdgeInsets.only(top: 60),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: pizzaThingList
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              handleTopping(e);
                              player.play(AssetSource(
                                  'audio/chick/pizza_${e['img']}.mp3'));
                            },
                            child: SizedBox(
                              width: width * 0.12,
                              height: height * 0.18,
                              child: Column(
                                children: [
                                  Image.asset(
                                    height: height * 0.08,
                                    width: width * 0.1,
                                    'assets/images/chick/pizza_thing_${e['img']}.png',
                                  ),
                                  Text(
                                    '${e['name']}',
                                    style: mapleText(
                                        24.0, FontWeight.w500, Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
