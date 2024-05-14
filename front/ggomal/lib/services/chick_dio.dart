import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';

Future<List> getChick() async {
  Dio dio = await useDio();
  final response = await dio.get('/chick');
  return response.data;
}

checkAudio(int gameNum, String sentence, String audio) async {
  FormData formData = FormData.fromMap({
    "gameNum": gameNum,
    "sentence": sentence,
    "kidVoice": await MultipartFile.fromFile(audio),
  });

  Dio dio = await useDio();
  final response = await dio.post('/chick/evaluation', data: formData);
  print(response.data);
  return response.data;
}

chickReword(int situationId, int getCoin) async {
  Dio dio = await useDio();

  final response = await dio.post('/chick', data: {
    "situationId": situationId,
    "getCoin": getCoin,
  });
  print(response.data);

}