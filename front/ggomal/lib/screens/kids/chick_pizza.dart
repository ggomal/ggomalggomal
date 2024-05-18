import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:ggomal/widgets/pizza_plate.dart';

class ChickPizzaScreen extends StatefulWidget {
  const ChickPizzaScreen({super.key});

  @override
  State<ChickPizzaScreen> createState() => _ChickPizzaScreenState();
}

class _ChickPizzaScreenState extends State<ChickPizzaScreen> {
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.play(AssetSource('audio/chick/pizza_start.mp3'));
  }

  @override
  void dispose() {
    super.dispose();
    player.stop();
  }

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
