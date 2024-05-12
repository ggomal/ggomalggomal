import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';

getFurniture() async{
  Dio dio = await useDio();
  final response = await dio.get('/furniture');

  List<dynamic> furnitureData = response.data;
  // for (var item in furnitureData) {
  //   print('ID: ${item['id']}, Name: ${item['name']}, Acquired: ${item['acquired']}');
  // }

  return furnitureData;
}

buyFurniture(int furnitureId) async {
  Dio dio = await useDio();

  try {
    final response = await dio.post('/furniture', data: {
      "furnitureId": furnitureId
    });
    print(response.data);

    return response.statusCode == 200;
  } catch (e) {
    print('Error buying furniture: $e');
    return false; // 에러 발생시 false 반환
  }
}