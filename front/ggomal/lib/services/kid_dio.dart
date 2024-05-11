import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';
import 'package:ggomal/get_storage.dart';

getCoin() async {
  Dio dio = await useDio();
  final response = await dio.get('/kid/coin');
  // print(]);
  return response.data['coin'];
}