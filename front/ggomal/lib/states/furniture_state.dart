import 'package:flutter/material.dart';

class FurnitureState with ChangeNotifier {
  List<Map<String, dynamic>> items = [
    {"asset": 'assets/images/home/sofa.png',"asset2": 'assets/images/home/sofa2.png', "audio": 'images/home/audio/sofa.mp3', "x": -0.45, "y": -0.43, "width": 650, "isVisible": false, "name" : "소파", "size" : 250, "count" : 2},
    {"asset": 'assets/images/home/tv.png', "asset2": 'assets/images/home/tv2.png', "audio": 'images/home/audio/tv.mp3', "x": -0.99, "y": -0.2, "width": 370, "isVisible": false, "name" : "텔레비전", "size" : 130, "count" : 3},
    {"asset": 'assets/images/home/table.png', "asset2": 'assets/images/home/table2.png',"audio": 'images/home/audio/table.mp3', "x": -0.45, "y": 0.4, "width": 650, "isVisible": false, "name" : "식탁", "size" : 250, "count" : 4},
    {"asset": 'assets/images/home/chair.png', "asset2": 'assets/images/home/chair2.png',"audio": 'images/home/audio/chair.mp3', "x": 0.5, "y": -0.1, "width": 350, "isVisible": false, "name" : "의자", "size" : 120, "count" : 5},
    {"asset": 'assets/images/home/window.png', "asset2": 'assets/images/home/window2.png',"audio": 'images/home/audio/window.mp3', "x": 0.5, "y": -0.9, "width": 300, "isVisible": false, "name" : "창문", "size" : 130, "count" : 6},
    {"asset": 'assets/images/home/photo.png', "asset2": 'assets/images/home/photo2.png',"audio": 'images/home/audio/photo.mp3', "x": -0.9, "y": -0.9, "width": 200, "isVisible": false, "name" : "액자", "size" : 80, "count" : 7},
  ];

  void toggleVisibility(int index) {
    items[index]['isVisible'] = !items[index]['isVisible'];
    notifyListeners();
  }

  void unlockItem(int index) {
    items[index]['asset2'] = items[index]['asset'];
    items[index]['isVisible'] = true;
    notifyListeners();
  }
}