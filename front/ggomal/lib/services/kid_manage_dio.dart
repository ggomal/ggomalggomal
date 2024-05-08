import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';
import 'package:intl/intl.dart';

signUpKid(String name, DateTime kidBirthDT, String gender, String kidImg,
    String kidNote, String parentName, String phone) async {
  try {
    Dio dio = await useDio();
    final response = await dio.post('/kid', data: {
      "name": name,
      "gender": gender,
      "phone": phone,
      "kidImg": kidImg,
      "kidBirthDT": DateFormat('yyyy-MM-dd').format(kidBirthDT),
      "kidNote": kidNote,
      "parentName": parentName
    });
    print(response);
    return "${name} 아이 등록에 성공하였습니다.";
  } catch (error) {
    return "아이 등록에 실패하였습니다.";
  }
}

Future<List> getKidList() async {
  Dio dio = await useDio();
  final response = await dio.get('/kid');
  return response.data;
}

Future getKid(String kidId) async {
  Dio dio = await useDio();
  final response = await dio.get('/kid/$kidId');
  print(response.data);
  return response.data;
}