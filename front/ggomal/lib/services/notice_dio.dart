import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';

postNotice(String kidId, String contents, List<String> homeworks) async {
  try {
    Dio dio = await useDio();
    await dio.post('/notice', data: {
      "kidId": kidId,
      "contents": contents,
      "homeworks": homeworks,
    });
    return "알림장 등록에 성공하였습니다.";
  } catch (error) {
    print(error);
    return "알림장 등록에 실패하였습니다.";
  }
}

Future<List> getNoticeList(String kidId, int month) async {
  Dio dio = await useDio();
  final response = await dio.get('/notice/$month', queryParameters: {
    "kidId": kidId,
  });
  return response.data;
}
