import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';

void main() {
  runApp(
    MaterialApp(home: MainScreen()),
  );
}


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  ParticleOptions particles = const ParticleOptions(
    baseColor: Colors.cyan,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    maxOpacity: 0.4,
    particleCount: 30,
    spawnMaxRadius: 25.0,
    spawnMaxSpeed: 30.0,
    spawnMinSpeed: 10,
    spawnMinRadius: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF8FF),
      body:
      AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
      ),
    );
  }
}
