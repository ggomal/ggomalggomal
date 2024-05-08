import 'package:ggomal/services/dio.dart';

Future<List> getChick() async {
    final response =  await useDio().get('/chick');
    return response.data;
}
//
// Future<List> getNoticeList(int kidId) async {
//   final response = await useDio().get('/notice/5', queryParameters: {
//     "kidId": kidId,
//   });
//   return response.data;
// }
