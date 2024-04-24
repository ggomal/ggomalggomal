import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

class BearScreen extends StatelessWidget {
  const BearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bear.png'),
          fit: BoxFit.cover, // 화면에 꽉 차게
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: NavBar(),
          body: Text('곰집입니다')),
    );
  }
}
