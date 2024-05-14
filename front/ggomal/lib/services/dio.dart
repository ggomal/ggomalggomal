import 'package:dio/dio.dart';
import 'package:ggomal/login_storage.dart';

Future<Dio> useDio() async{
  LoginStorage _storage = await LoginStorage();
  // 아이 토큰
  // String loginJwt = 'eyJhbGciOiJIUzI1NiJ9.eyJjZW50ZXJJZCI6Miwicm9sZSI6IktJRCIsIm1lbWJlck5hbWUiOiLrp4jripjslYTsnbQiLCJtZW1iZXJJZCI6NCwic3ViIjoia2lkMSIsImlhdCI6MTcxNDkxMjg4MiwiZXhwIjoxMDE3MTQ5MTI4ODJ9.poP4jnnsdQhINLLD5RM9zDQNFcsJ_LQ57PDqB0exdJ8';

  // 선생님 토큰
  // String loginJwt = 'eyJhbGciOiJIUzI1NiJ9.eyJjZW50ZXJJZCI6Miwicm9sZSI6IlRFQUNIRVIiLCJtZW1iZXJOYW1lIjoi66eI64qY7ISg7IOdIiwibWVtYmVySWQiOjMsInN1YiI6InRlYWNoZXIxIiwiaWF0IjoxNzE0OTEyOTg1LCJleHAiOjEwMTcxNDkxMjk4NX0.Jj5OMXnMEINnP0FteSWVzGtzsEPJWGhnML3HS849nSI';

  // 로그인 실행시 토큰
  String? loginJwt = await _storage.getJwt();

  final options = BaseOptions(
    baseUrl: 'https://k10e206.p.ssafy.io/api/v1',
    headers: {'Authorization': 'Bearer $loginJwt'},
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 30),
  );
  return Dio(options);

}

