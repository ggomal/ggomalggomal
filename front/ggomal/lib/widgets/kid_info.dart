import 'package:flutter/material.dart';
import 'package:ggomal/widgets/create_bingo.dart';

class KidInfo extends StatelessWidget {
  const KidInfo({super.key});

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> kid = {
      "kid_id": 2,
      "name": "춘식이",
      "age": 5,
      "id": "chunsik",
      "password": "chunsik123",
      "birth_DT": "2024-04-01",
      "parent_name": "박수빈",
      "parent_phone": "010-0000-0000",
      "kid_note": "빙고 규칙을 자세히 알려주어야 합니다.",
      "kid_img_url": "assets/images/manager/chunsik.jpg"
    };

    TextStyle baseText(double size, FontWeight weight) {
      return TextStyle(
        fontFamily: 'NanumS',
        fontWeight: weight,
        fontSize: size,
        color: Colors.black,
      );
    }

    Widget textLine(Map<String, String> text) {
      return Flexible(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  "${text['field']}",
                  style: baseText(12.0, FontWeight.w800),
                ),
              ),
              Text(
                "${text['data']}",
                style: baseText(12.0, FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20.0),
      width: 250,
      height: 400,
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            blurRadius: 5.0,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              kid['kid_img_url'],
              width: 150.0,
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          ...[
            {"field": "이름", "data": "${kid["name"]}"},
            {"field": "생년월일", "data": "${kid["birth_DT"]} (만 ${kid["age"]}세)"},
            {"field": "아이디", "data": "${kid["id"]}"},
            {"field": "비밀번호", "data": "${kid["password"]}"},
            {"field": "보호자 연락처", "data": "${kid["parent_phone"]}"},
          ].map((e) => textLine(e)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              "아이 특이사항",
              style: baseText(12.0, FontWeight.w800),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "${kid['kid_note']}",
              style: baseText(12.0, FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => CreateBingoModal(),
            ),
            child: Text("아이와 게임하기"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFAA8D),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
