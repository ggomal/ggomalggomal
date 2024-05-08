import 'package:ggomal/services/dio.dart';

Future<List> getChick() async {
    final response =  await useDio().get('/chick');
    return response.data;
}
