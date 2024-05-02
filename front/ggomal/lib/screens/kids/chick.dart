import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/utils/navbar.dart';

class ChickScreen extends StatelessWidget {
  const ChickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/chick/chick_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: NavBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 120.0,
            vertical: 10.0,
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/chick/chick_box.png',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100.0, 150.0, 100.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [['chick_pizza', '/pizza'], ['egg', ''], ['egg', ''], ['egg', '']]
                      .map(
                        (e) =>
                            InkWell(
                              onTap: () {
                                context.go('/kids/chick${e[1]}');
                              },
                              child:
                          Image.asset(
                            width: 150.0,
                            'assets/images/chick/${e[0]}.png',
                          ),
                            ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
