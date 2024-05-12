import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';

frogReword() async {
  Dio dio = await useDio();

  final response = await dio.post('/frog/end', data: {
    "playTime": 0.0,
    "durationSec": 0.0,
    "length": 0.0
  });
  print(response.data);

}