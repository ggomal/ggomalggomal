import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

class ChickCleanScreen extends StatelessWidget {
  const ChickCleanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/chick/clean_bg.png"),
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
                    flex: 4,
                    child: Image.asset(
                      height: 600.0,
                      'assets/images/chick/thatched_house.png',
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Image.asset(
                      'assets/images/chick/clean_character.png',
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
