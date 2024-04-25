import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

class FrogScreen extends StatelessWidget {
  const FrogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/frog/frog_screen.png"),
          fit: BoxFit.cover, // 화면에 꽉 차게
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: NavBar(),
          body: Text('개구리집입니다')),
    );
  }
}
