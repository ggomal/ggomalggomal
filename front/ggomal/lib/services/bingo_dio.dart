import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';

sendBingoAudio(String audio, String word, int wordId, String count, int gameNum) async {

  FormData formData = FormData.fromMap({
    "kidVoice": await MultipartFile.fromFile(audio),
    "letter": word,
    "wordId": wordId,
    "pronCount": count,
    "gameNum": gameNum
  });

  Dio dio = await useDio();
  final response = await dio.post('/bear/evaluationV2', data: formData);
  var rresponse = response.data;
  print('빙고 음성 데이터 보내면 응답 $rresponse');
  return response.data;
}