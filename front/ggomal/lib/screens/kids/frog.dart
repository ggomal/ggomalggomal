import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

import '../../widgets/percent_bar.dart';

class FrogScreen extends StatelessWidget {
  const FrogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      body: Stack(
        children: [
          Image.asset(
            "assets/images/frog/frog_screen.png",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          WhaleSea(),
        ],
      ),
    );
  }
}

class WhaleSea extends StatefulWidget {
  const WhaleSea({Key? key}) : super(key: key);

  @override
  State<WhaleSea> createState() => _WhaleSeaState();
}

class _WhaleSeaState extends State<WhaleSea> {
  late int _fishCount = 0;

  final List<Map<String, dynamic>> _fishLocation = [
    {"x": -0.7, "y": 0.7, "isVisible": true},
    {"x": -0.4, "y": -0.2, "isVisible": true},
    {"x": -0.3, "y": 0.2, "isVisible": true},
    {"x": -0.2, "y": -0.7, "isVisible": true},
    {"x": -0.1, "y": 0.6, "isVisible": true},
    {"x": 0.1, "y": -0.6, "isVisible": true},
    {"x": 0.4, "y": 0.2, "isVisible": true},
    {"x": 0.5, "y": 0.8, "isVisible": true},
    {"x": 0.6, "y": 0.5, "isVisible": true},
    {"x": 0.7, "y": -0.5, "isVisible": true},
  ];

  void _eatFish() {
    setState(() {
      _fishCount += 1;
    });
  }

  void _eatItem(int index) {
    setState(() {
      _fishCount += 1;
      _fishLocation[index]['isVisible'] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._fishLocation.asMap().entries.map((entry) {
          final int index = entry.key;
          print(index);
          final Map<String, dynamic> fish = entry.value;
          print(fish);
          return fish['isVisible']
              ? Positioned(
            left: (fish['x'] as double) * MediaQuery.of(context).size.width / 2 + MediaQuery.of(context).size.width / 2,
            top: (fish['y'] as double) * MediaQuery.of(context).size.height / 2 + MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              onTap: () => _eatItem(index),
              child: Image.asset(
                "assets/images/frog/banana.png",
                width: 70,
              ),
            ),
          )
              : Container();
        }).toList(),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _eatFish,
              child: Text('Eat Fish'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Text("Fish count: $_fishCount"),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 200,
            height: 80,
            padding: const EdgeInsets.all(20),
            child: PercentBar({
              "count": _fishCount,
              "barColor": Color(0xFFFF835C),
              "imgUrl": "assets/images/frog/fruits.png"
            }),
          ),
        )
      ],
    );
  }
}


