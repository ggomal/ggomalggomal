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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  height: 500.0,
                  'assets/images/chick/pizza_dough.png',
                ),
                Stack(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [['ham', 'paprika'], ['meat', 'mushroom'], ['tomato', 'olive']]
                            .map(
                              (e) => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: e.map((img) => Image.asset(
                                  height: 140,
                                  width: 140,
                                  'assets/images/chick/$img.png',
                                ),).toList(),
                              )

                            )
                            .toList(),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
