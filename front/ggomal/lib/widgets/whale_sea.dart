import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ggomal/widgets/percent_bar.dart';

class WhaleSea extends StatefulWidget {
  const WhaleSea({super.key});

  @override
  State<WhaleSea> createState() => _WhaleSeaState();
}

class _WhaleSeaState extends State<WhaleSea> {
  Alignment _alignment = Alignment.center;

  late Timer _timer;

  late int _fishCount = 0;

  final List<Map<String, dynamic>> _fishLocation = [
    {"x": -0.7, "y" : 0.7, "isVisible": true},
    {"x": -0.4, "y" : -0.2, "isVisible": true},
    {"x": -0.3, "y" : 0.2, "isVisible": true},
    {"x": -0.2, "y" : -0.7, "isVisible": true},
    {"x": -0.1, "y" : 0.6, "isVisible": true},
    {"x": 0.1, "y" : -0.6, "isVisible": true},
    {"x": 0.4, "y" : 0.2, "isVisible": true},
    {"x": 0.5, "y" : 0.8, "isVisible": true},
    {"x": 0.6, "y" : 0.5, "isVisible": true},
    {"x": 0.7, "y" : -0.5, "isVisible": true},
  ];


  void _startMove(List<double> direction) {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(
        () {
          double x = _alignment.x + direction[0];
          double y = _alignment.y + direction[1];
          if (x >= -1 && x <= 1 && y >= -1 && y <= 1) {
            _alignment += Alignment(direction[0], direction[1]);
            int fishIndex = _fishLocation.indexWhere((location) => x + 0.06 > location["x"]! && x - 0.16 < location["x"]! && y + 0.21 > location["y"]! && y - 0.21 < location["y"]!);

            if (fishIndex != -1 && _fishLocation[fishIndex]['isVisible']){
              _eatFish(fishIndex);
            }
          }
        },
      );
    });
  }

  void _stopMove() {
    _timer.cancel();
  }

  void _eatFish(int fishIndex) {
    setState(
        (){
          _fishCount += 1;
          _fishLocation[fishIndex]['isVisible'] = false;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanCancel: () => _stopMove(),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: _alignment,
            child: Image.asset(
              'assets/images/whale/whale_diver.png',
              width: 200.0,
            ),
          ),
          ..._fishLocation.map(
          (e) =>
          e['isVisible'] ?
          Align(
            alignment: Alignment(e['x'] as double, e['y'] as double),
            child: Image.asset(
              "assets/images/whale/fish_pink.png",
              width: 50,
            ),
          ) : Text(""),
          ).toList(),
          ...[
            {
              "direct": "top",
              "coord": [0.0, -0.1],
              "location": Alignment.topCenter,
            },
            {
              "direct": "bottom",
              "coord": [0.0, 0.1],
              "location": Alignment.bottomCenter,
            },
            {
              "direct": "left",
              "coord": [-0.07, 0.0],
              "location": Alignment.centerLeft,
            },
            {
              "direct": "right",
              "coord": [0.07, 0.0],
              "location": Alignment.centerRight,
            },
          ]
              .map(
                (e) => Align(
                  alignment: e['location'] as Alignment,
                  child: GestureDetector(
                    onTapDown: (_) => _startMove(e['coord'] as List<double>),
                    onTapUp: (_) => _stopMove(),
                    onTapCancel: () => _stopMove(),
                    child: Image.asset(
                      "assets/images/whale/button_${e['direct']}.png",
                      width: 130,
                    ),
                  ),
                ),
              )
              .toList(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 200,
              height: 80,
              padding: const EdgeInsets.all(20),
              child: PercentBar({"count": _fishCount, "barColor": Color(0xFFFF835C) ,"imgUrl": "assets/images/whale/fish_pink.png"}),
            ),
          ),
        ],
      ),
    );
  }
}
