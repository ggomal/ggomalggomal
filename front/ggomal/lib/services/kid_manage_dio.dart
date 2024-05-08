import 'package:ggomal/services/dio.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:convert';

signUpKid(String name, DateTime kidBirthDT, String gender, kidImg,
    String kidNote, String parentName, String phone) async {
  String base64Image = '';
  try {
    if (kidImg != null) {
      final bytes = File(kidImg!.path).readAsBytesSync();
      base64Image = base64Encode(bytes);
    }
    print({
      "name": name,
      "gender": gender,
      "phone": phone,
      "kidImg": base64Image,
      "kidBirthDT": DateFormat('yyyy-MM-dd').format(kidBirthDT),
      "kidNote": kidNote,
      "parentName": parentName
    });
    final response = await useDio().post('/kid', data: {
      "name": name,
      "gender": gender,
      "phone": phone,
      "kidImg": base64Image,
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
  final response = await useDio().get('/kid');
  return response.data;
}

Future getKid(String kidId) async {
  final response = await useDio().get('/kid/$kidId');
  print(response.data);
  return response.data;
}