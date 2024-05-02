import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/start.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment(0, 0.5),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                        onTap: () {
              context.go('/kids');
                        },
                        child: Image.asset('assets/images/start_button.png', width: 400),
                      ),
            )));
  }
}
