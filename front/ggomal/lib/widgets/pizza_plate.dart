import 'package:flutter/material.dart';
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
    {'img': 0, 'top': 80.0, 'left': 120.0, 'isVisible': true},
    {'img': 0, 'top': 230.0, 'left': 150.0, 'isVisible': true},
    {'img': 0, 'top': 130.0, 'left': 340.0, 'isVisible': true},
    {'img': 0, 'top': 110.0, 'left': 190.0, 'isVisible': true},
    {'img': 0, 'top': 100.0, 'left': 300.0, 'isVisible': true},
    {'img': 0, 'top': 240.0, 'left': 270.0, 'isVisible': true},
    {'img': 0, 'top': 250.0, 'left': 200.0, 'isVisible': true},
    {'img': 0, 'top': 60.0, 'left': 260.0, 'isVisible': true},
    {'img': 0, 'top': 200.0, 'left': 100.0, 'isVisible': true},
    {'img': 0, 'top': 180.0, 'left': 180.0, 'isVisible': true},
    {'img': 0, 'top': 150.0, 'left': 80.0, 'isVisible': true},
    {'img': 0, 'top': 165.0, 'left': 295.0, 'isVisible': true},
    {'img': 0, 'top': 150.0, 'left': 220.0, 'isVisible': true},
    {'img': 0, 'top': 195.0, 'left': 345.0, 'isVisible': true},
    {'img': 0, 'top': 70.0, 'left': 200.0, 'isVisible': true},
    {'img': 0, 'top': 200.0, 'left': 250.0, 'isVisible': true},
    {'img': 0, 'top': 135.0, 'left': 260.0, 'isVisible': true},
    {'img': 0, 'top': 140.0, 'left': 140.0, 'isVisible': true},
  ];

  void handleTopping(Map<String, dynamic> thing) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ChickSpeechModal({
        "game": "pizza",
        "name": thing['name'],
        "img": thing['img'],
        "ending": "넣어"
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
          if (toppingIndex == 18) {print("게임 끝")}
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 5,
          child: Stack(
            children: [
              Image.asset(
                height: 500.0,
                'assets/images/chick/pizza_dough.png',
              ),
              ...toppings.map(
                    (e) => e['img'] != 0
                    ? Positioned(
                  top: e['top'] as double,
                  left: e['left'] as double,
                  child: Image.asset(
                    "assets/images/chick/pizza_thing_${e['img']}.png",
                    width: 40,
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
                  height: 500.0,
                  'assets/images/chick/pizza_plate.png',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40.0,
                    horizontal: 30.0,
                  ),
                  child: Wrap(
                    children: pizzaThingList
                        .map(
                          (e) => GestureDetector(
                        onTap: () {
                          handleTopping(e);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 3.0,
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                height: 90,
                                width: 90,
                                'assets/images/chick/pizza_thing_${e['img']}.png',
                              ),
                              Text(
                                '${e['name']}',
                                style: mapleText(
                                    28.0, FontWeight.w500, Colors.black),
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
