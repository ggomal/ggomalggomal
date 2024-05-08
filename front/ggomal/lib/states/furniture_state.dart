import 'package:flutter/material.dart';

class FurnitureState with ChangeNotifier {
  List<Map<String, dynamic>> items = [
    {"asset": 'assets/images/home/sofa.png', "audio": 'images/home/audio/sofa.mp3', "x": -0.45, "y": -0.43, "width": 650, "isVisible": true},
    {"asset": 'assets/images/home/tv.png', "audio": 'images/home/audio/tv.mp3', "x": -0.99, "y": -0.2, "width": 370, "isVisible": true},
    {"asset": 'assets/images/home/table.png', "audio": 'images/home/audio/table.mp3', "x": -0.45, "y": 0.4, "width": 650, "isVisible": true},
    {"asset": 'assets/images/home/chair.png', "audio": 'images/home/audio/chair.mp3', "x": 0.5, "y": -0.1, "width": 350, "isVisible": true},
    {"asset": 'assets/images/home/window.png', "audio": 'images/home/audio/window.mp3', "x": 0.5, "y": -0.9, "width": 300, "isVisible": true},
    {"asset": 'assets/images/home/photo.png', "audio": 'images/home/audio/photo.mp3', "x": -0.9, "y": -0.9, "width": 200, "isVisible": true},
  ];

  void toggleVisibility(int index) {
    items[index]['isVisible'] = !items[index]['isVisible'];
    notifyListeners();
  }
}