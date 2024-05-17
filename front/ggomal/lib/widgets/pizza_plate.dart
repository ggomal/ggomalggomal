import 'package:flutter/material.dart';
import 'package:ggomal/services/chick_dio.dart';
import 'package:ggomal/utils/game_bosang_dialog.dart';
import 'package:ggomal/widgets/chick_speech.dart';
import 'package:ggomal/constants.dart';

class PizzaPlate extends StatefulWidget {
  const PizzaPlate({super.key});

  @override
  State<PizzaPlate> createState() => _PizzaPlateState();
}

class _PizzaPlateState extends State<PizzaPlate> {
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
    {'img': 0, 'top': 150.0, 'left': 150.0, 'isVisible': true},
    {'img': 0, 'top': 270.0, 'left': 270.0, 'isVisible': true},
    {'img': 0, 'top': 210.0, 'left': 340.0, 'isVisible': true},
    {'img': 0, 'top': 130.0, 'left': 220.0, 'isVisible': true},
    {'img': 0, 'top': 190.0, 'left': 110.0, 'isVisible': true},
    {'img': 0, 'top': 310.0, 'left': 180.0, 'isVisible': true},
    {'img': 0, 'top': 200.0, 'left': 420.0, 'isVisible': true},
    {'img': 0, 'top': 330.0, 'left': 350.0, 'isVisible': true},
    {'img': 0, 'top': 250.0, 'left': 200.0, 'isVisible': true},
    {'img': 0, 'top': 185.0, 'left': 260.0, 'isVisible': true},
    {'img': 0, 'top': 335.0, 'left': 280.0, 'isVisible': true},
    {'img': 0, 'top': 305.0, 'left': 420.0, 'isVisible': true},
    {'img': 0, 'top': 130.0, 'left': 300.0, 'isVisible': true},
    {'img': 0, 'top': 265.0, 'left': 345.0, 'isVisible': true},
    {'img': 0, 'top': 255.0, 'left': 120.0, 'isVisible': true},
    {'img': 0, 'top': 140.0, 'left': 385.0, 'isVisible': true},
    {'img': 0, 'top': 260.0, 'left': 440.0, 'isVisible': true},
    {'img': 0, 'top': 200.0, 'left': 200.0, 'isVisible': true},
  ];

  void handleTopping(Map<String, dynamic> thing) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ChickSpeechModal({
        "gameNum": 1,
        "game": "pizza",
        "name": thing['name'],
        "img": thing['img'],
        "ending": "넣어요"
      }),
    ).then((value) => {
          if (value)
            {
              setState(() {
                for (int i = 0; i < 3; i++) {
                  toppings[toppingIndex]['img'] = thing['img'];
                  toppingIndex += 1;
                }
              }),
              if (toppingIndex == 18)
                {
                  chickReward(2, 2),
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        GameContinueDialog(continuePage:'/chick/pizza', count: 2),
                  )
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
                          width:  width * 0.03,
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
