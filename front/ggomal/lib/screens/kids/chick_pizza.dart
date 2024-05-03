import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:ggomal/widgets/pizza_plate.dart';

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
                  Flexible(flex: 4, child: PizzaPlate()),
                  Flexible(
                    flex: 1,
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
