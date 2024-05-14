import 'package:flutter/material.dart';
import 'package:ggomal/services/dio.dart';

class FurnitureProvider with ChangeNotifier {
  List<Map<String, dynamic>> items = [];

  final List<Map<String, dynamic>> refer_items = [
    {"furnitureId": 0 ,"asset": 'assets/images/home/sofa.png',"asset2": 'assets/images/home/sofa2.png', "audio": 'images/home/audio/sofa.mp3', "x": -0.45, "y": -0.43, "width": 650, "isVisible": false, "name" : "소파", "size" : 250, "count" : 2},
    {"furnitureId": 0 ,"asset": 'assets/images/home/tv.png', "asset2": 'assets/images/home/tv2.png', "audio": 'images/home/audio/tv.mp3', "x": -0.99, "y": -0.2, "width": 370, "isVisible": false, "name" : "텔레비전", "size" : 130, "count" : 3},
    {"furnitureId": 0 ,"asset": 'assets/images/home/table.png', "asset2": 'assets/images/home/table2.png',"audio": 'images/home/audio/table.mp3', "x": -0.45, "y": 0.4, "width": 650, "isVisible": false, "name" : "식탁", "size" : 250, "count" : 4},
    {"furnitureId": 0 ,"asset": 'assets/images/home/chair.png', "asset2": 'assets/images/home/chair2.png',"audio": 'images/home/audio/chair.mp3', "x": 0.5, "y": -0.1, "width": 350, "isVisible": false, "name" : "의자", "size" : 120, "count" : 5},
    {"furnitureId": 0 ,"asset": 'assets/images/home/window.png', "asset2": 'assets/images/home/window2.png',"audio": 'images/home/audio/window.mp3', "x": 0.5, "y": -0.9, "width": 300, "isVisible": false, "name" : "창문", "size" : 130, "count" : 6},
    {"furnitureId": 0 ,"asset": 'assets/images/home/photo.png', "asset2": 'assets/images/home/photo2.png',"audio": 'images/home/audio/photo.mp3', "x": -0.9, "y": -0.9, "width": 200, "isVisible": false, "name" : "액자", "size" : 80, "count" : 7},
  ];

  void fetchFurniture() async {
    var dio = await useDio();
    var response = await dio.get('/furniture');
    if (response.statusCode == 200) {
      var data = response.data as List;
      items = data.map<Map<String, dynamic>>((item) => {
        "furnitureId": item['id'],
        "asset": refer_items[item['id'] - 1]['asset'],
        "asset2": refer_items[item['id'] - 1]['asset2'],
        "audio": refer_items[item['id'] - 1]['audio'],
        "x": refer_items[item['id'] - 1]['x'], // 예시 값, 실제 애플리케이션에서는 적절히 조정
        "y": refer_items[item['id'] - 1]['y'], // 예시 값
        "width": refer_items[item['id'] - 1]['width'], // 예시 값
        "isVisible": item['acquired'],
        "name": item['name'],
        "size": refer_items[item['id'] - 1]['size'], // 예시 값
        "count": refer_items[item['id'] - 1]['count'],
      }).toList();
      notifyListeners();  // Notify all the listening widgets to rebuild
    }
  }

  Future<void> buyFurniture(int index) async {
    var dio = await useDio();
    try {
      var response = await dio.post('/furniture', data: {
        "furnitureId": index
      });
      if (response.statusCode == 200) {
        // 가정: 서버에서 구매 성공 후의 가구 상태를 반환
        items[index]['isVisible'] = true; // 예: 구매 후에는 아이템이 보이게 설정
        notifyListeners();
      }
    } catch (e) {
      print('구매 에러: $e');
    }
  }
}
