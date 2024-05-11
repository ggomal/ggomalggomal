import 'package:flutter/material.dart';

class FlyState with ChangeNotifier {
  int flyCount = 0;
  List<Map<String, dynamic>> flyLocation = [
    // 초기 위치 데이터
  ];

  int get fishCount => flyCount;
  List<Map<String, dynamic>> get fishLocation => _fishLocation;

  void eatItem(int index) {
    _fishCount += 1;
    _fishLocation[index]['isVisible'] = false;
    notifyListeners();
  }
}
