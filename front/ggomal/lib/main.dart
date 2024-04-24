import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';

// 메인
void main() {
  runApp(
    MaterialApp(home: LoginScreen()),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> with TickerProviderStateMixin {
  final List<ParticleOptionsData> particleOptionsList = [
    ParticleOptionsData(baseColor: Colors.cyan),
    ParticleOptionsData(baseColor: Colors.yellow),
    ParticleOptionsData(baseColor: Colors.pink),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF8FF),
      body: Stack(
        children: [
          ...particleOptionsList
              .map((data) => buildAnimatedBackground(data.particleOptions))
              .toList(),
          Container(
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedBackground(ParticleOptions particleOptions) {
    return Container(
      child: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particleOptions),
        child: Container(),
      ),
    );
  }
}

// particle 옵션, color만 받아서 추가
class ParticleOptionsData {
  final Color baseColor;

  const ParticleOptionsData({required this.baseColor});

  ParticleOptions get particleOptions => ParticleOptions(
        baseColor: baseColor,
        spawnOpacity: 0.0,
        opacityChangeRate: 0.25,
        minOpacity: 0.1,
        maxOpacity: 0.4,
        particleCount: 10,
        spawnMaxRadius: 25.0,
        spawnMaxSpeed: 30.0,
        spawnMinSpeed: 10,
        spawnMinRadius: 10.0,
      );
}
