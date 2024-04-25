import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

class ChickScreen extends StatelessWidget {
  const ChickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/chick_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: NavBar(),
        body: Text("여긴 병아리집"),
      ),
    );
  }
}
