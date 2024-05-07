import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../widgets/navbar_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  final List<Map<String, dynamic>> _items = [
    {"asset": 'assets/images/home/sofa.png', "audio": 'images/home/audio/sofa.mp3', "x": -0.45, "y": -0.43, "width": 650, "isVisible": true},
    {"asset": 'assets/images/home/tv.png', "audio": 'images/home/audio/tv.mp3', "x": -0.99, "y": -0.2, "width": 370, "isVisible": true},
    {"asset": 'assets/images/home/table.png', "audio": 'images/home/audio/table.mp3', "x": -0.45, "y": 0.4, "width": 650, "isVisible": true},
    {"asset": 'assets/images/home/chair.png', "audio": 'images/home/audio/chair.mp3', "x": 0.5, "y": -0.1, "width": 350, "isVisible": true},
    {"asset": 'assets/images/home/window.png', "audio": 'images/home/audio/window.mp3', "x": 0.5, "y": -0.9, "width": 300, "isVisible": true},
    {"asset": 'assets/images/home/photo.png', "audio": 'images/home/audio/photo.mp3', "x": -0.9, "y": -0.9, "width": 200, "isVisible": true},
  ];

  void toggleVisibility(int index) {
    setState(() {
      _items[index]['isVisible'] = !_items[index]['isVisible'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: NavBarHome(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: _items.map((item) {
            if (!item['isVisible']) return Container();
            return Positioned(
              left: (screenSize.width / 2) * (1 + item['x']),
              top: (screenSize.height / 2) * (1 + item['y']),
              child: InkWell(
                onTap: () {
                  player.play(AssetSource(item['audio']));
                  toggleVisibility(_items.indexOf(item));
                },
                child: Image.asset(item['asset'], width: item['width'] / 1.0,),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
