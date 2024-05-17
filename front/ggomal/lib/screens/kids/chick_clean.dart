import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:ggomal/widgets/chick_thatched_house.dart';

class ChickCleanScreen extends StatefulWidget {
  const ChickCleanScreen({super.key});

  @override
  State<ChickCleanScreen> createState() => _ChickCleanScreenState();
}

class _ChickCleanScreenState extends State<ChickCleanScreen> {
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.play(AssetSource('audio/chick/clean_start.mp3'));
  }

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
                  ChickThatchedHouse(),
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
