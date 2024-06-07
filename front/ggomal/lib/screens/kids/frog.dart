import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:ggomal/widgets/frog_game.dart';
import 'package:ggomal/widgets/whale_sea.dart';


class FrogScreen extends StatefulWidget {
  const FrogScreen({super.key});

  @override
  State<FrogScreen> createState() => _FrogScreenState();
}

class _FrogScreenState extends State<FrogScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/whale/whale_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: NavBar(),
        body: FrogTown(),
      ),
    );
  }
}
