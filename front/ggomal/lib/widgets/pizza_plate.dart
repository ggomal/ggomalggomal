import 'package:flutter/material.dart';
import 'package:ggomal/widgets/chick_speech.dart';
import 'package:ggomal/constants.dart';

class PizzaPlate extends StatefulWidget {
  const PizzaPlate({super.key});

  @override
  State<PizzaPlate> createState() => _PizzaPlateState();
}

class _PizzaPlateState extends State<PizzaPlate> {

  List<Map<String, dynamic>> pizzaThingList = [
    {'img': 1, 'name': '햄'},
    {'img': 2, 'name': '피망'},
    {'img': 3, 'name': '고기'},
    {'img': 4, 'name': '버섯'},
    {'img': 5, 'name': '토마토'},
    {'img': 6, 'name': '올리브'},
  ];

  void handlePizzaThing(Map<String, dynamic> thing) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ChickSpeechModal({
        "game": "pizza",
        "name": thing['name'],
        "img": thing['img'],
        "ending": "올려줘"
      }),
    ).then((value) => {
          if (value) {setState(() {})}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 5,
          child: Image.asset(
            height: 500.0,
            'assets/images/chick/pizza_dough.png',
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
                              handlePizzaThing(e);
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
                                    style: mapleText(28.0, FontWeight.w500, Colors.black),
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
