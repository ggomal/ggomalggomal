import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';

checkAudio(String audio) async {
  FormData formData = FormData.fromMap({
    "sentence": "아에이오우",
    "kidVoice": await MultipartFile.fromFile(audio),
  });

  Dio dio = await useDio();
  final response = await dio.post('/whale/evaluation', data: formData);
  print(response.data);
  return response.data;
}

whaleReward(double maxTime) async {
  Dio dio = await useDio();

  final response = await dio.post('/whale/end', data: {
    "maxTime": maxTime,
  });
  print(response.data);
}