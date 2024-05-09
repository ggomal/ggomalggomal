import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';

Future<List> getChick() async {
    Dio dio = await useDio();
    final response =  await dio.get('/chick');
    return response.data;
}