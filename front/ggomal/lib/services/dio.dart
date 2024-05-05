import 'package:dio/dio.dart';

final options = BaseOptions(
  baseUrl: 'https://k10e206.p.ssafy.io/api/v1',
  headers: {'Authorization': 'Bearer '},
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 3),
);


final dio = Dio(options);

