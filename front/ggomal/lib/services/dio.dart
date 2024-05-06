import 'package:dio/dio.dart';



Dio useDio() {
  final options = BaseOptions(
    baseUrl: 'https://k10e206.p.ssafy.io/api/v1',
    headers: {'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJjZW50ZXJJZCI6Miwicm9sZSI6IlRFQUNIRVIiLCJtZW1iZXJOYW1lIjoi66eI64qY7ISg7IOdIiwibWVtYmVySWQiOjMsInN1YiI6InRlYWNoZXIxIiwiaWF0IjoxNzE0OTEyOTg1LCJleHAiOjEwMTcxNDkxMjk4NX0.Jj5OMXnMEINnP0FteSWVzGtzsEPJWGhnML3HS849nSI'},
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  );


  return Dio(options);

}

