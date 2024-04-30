import 'package:flutter/material.dart';
import 'dart:async';

class WhaleSea extends StatefulWidget {
  const WhaleSea({super.key});

  @override
  State<WhaleSea> createState() => _WhaleSeaState();
}

class _WhaleSeaState extends State<WhaleSea> {
  Alignment _alignment = Alignment.center;

  late Timer _timer;

  void _startMove(List<double> direction) {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(
        () {
          double x = _alignment.x + direction[0];
          double y = _alignment.y + direction[1];

          if (x >= -1 && x <= 1 && y >= -1 && y <= 1) {
            _alignment += Alignment(direction[0], direction[1]);
          }
        },
      );
    });
  }

  void _stopMove() {
    _timer.cancel();
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
          Stack(
            children: [
              {
                "direct": "top",
                "coord": [0.0, -0.1],
                "location": Alignment.topCenter,
                "word": "아"
              },
              {
                "direct": "bottom",
                "coord": [0.0, 0.1],
                "location": Alignment.bottomCenter,
                "word": "에"
              },
              {
                "direct": "left",
                "coord": [-0.07, 0.0],
                "location": Alignment.centerLeft,
                "word": "이"
              },
              {
                "direct": "right",
                "coord": [0.07, 0.0],
                "location": Alignment.centerRight,
                "word": "오"
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
          ),
        ],
      ),
    );
  }
}
