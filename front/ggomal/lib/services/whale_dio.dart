import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';

whaleReword(double maxTime) async {
  Dio dio = await useDio();

  final response = await dio.post('/whale/end', data: {
    "maxTime": maxTime,
  });
  print(response.data);

}