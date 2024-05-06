import 'package:ggomal/services/dio.dart';

Future<List> postNotice(int kidId, String contents, List<String> homeworks) async {
  await useDio().post('/notice', data: {
    "kidId": kidId,
    "contents": contents,
    "homeworks": homeworks,
  });

  return getNoticeList(kidId);
}

Future<List> getNoticeList(int kidId) async {
  final response = await useDio().get('/notice/5', queryParameters: {
    "kidId": kidId,
  });
  print("여기서 데이터를 받아옵니다");
  print(response.data[response.data.length - 1]);
  return response.data;
}
