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
      setState(() {
          _alignment += Alignment(direction[0], direction[1]);
      });
    });
  }

  void _stopMove() {
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 150,
      ),
      child: GestureDetector(
        onPanCancel: () => _stopMove(),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/whale/whale_sea.png',
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: _alignment,
              child: Image.asset(
                'assets/images/whale/whale_character.png',
                width: 200.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                [0.0, 0.1],
                [0.1, 0.0],
                [0.0, -0.1],
                [-0.1, 0.0]
              ]
                  .map(
                    (e) => GestureDetector(
                      onTapDown: (_) => _startMove(e),
                      onTapUp: (_) => _stopMove(),
                      onTapCancel: () => _stopMove(),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('$e 방향'),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }


}
