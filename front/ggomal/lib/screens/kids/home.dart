import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home.png'),
          fit: BoxFit.cover, // 화면에 꽉 차게
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: NavBar(),
          body: Text('우리 아이 집')),
    );
  }
}
