import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

class ChickPizzaScreen extends StatelessWidget {
  const ChickPizzaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/chick/pizza_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: NavBar(),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                            children: [
                              {'img': 'ham', 'name': '햄'},
                              {'img': 'paprika', 'name': '피망'},
                              {'img': 'meat', 'name': '고기'},
                              {'img': 'mushroom', 'name': '버섯'},
                              {'img': 'tomato', 'name': '토마토'},
                              {'img': 'olive', 'name': '올리브'},
                            ]
                                .map(
                                  (e) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0,
                                      vertical: 3.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          height: 90,
                                          width: 90,
                                          'assets/images/chick/${e['img']}.png',
                                        ),
                                        Text(
                                          '${e['name']}',
                                          style: TextStyle(
                                            fontFamily: 'Maplestory',
                                            fontSize: 28.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Image.asset(
                      'assets/images/chick/pizza_character.png',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
