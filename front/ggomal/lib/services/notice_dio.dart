import 'package:ggomal/services/dio.dart';

postNotice(int kidId, String contents, List<String> homeworks) async {
  try {
    await useDio().post('/notice', data: {
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

Future<List> getNoticeList(int kidId) async {
  final response = await useDio().get('/notice/5', queryParameters: {
    "kidId": kidId,
  });
  print("여기서 데이터를 받아옵니다");
  print(response.data[response.data.length - 1]);
  return response.data;
}
