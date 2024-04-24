import 'package:flutter/material.dart';

class WhaleScreen extends StatelessWidget {
  const WhaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/whale_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 100,
          ),
          child: Image.asset(
            'assets/images/whale_sea.png',
          ),
        ),
      ),
    );
  }
}
