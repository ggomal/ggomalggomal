import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:ggomal/widgets/whale_sea.dart';


class WhaleScreen extends StatefulWidget {
  const WhaleScreen({super.key});

  @override
  State<WhaleScreen> createState() => _WhaleScreenState();
}

class _WhaleScreenState extends State<WhaleScreen> {
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.play(AssetSource('audio/whale/whale_start.mp3'));
  }

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
        body: WhaleSea(),
      ),
    );
  }
}
