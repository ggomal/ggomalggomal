import 'package:flutter/material.dart';

class KidReport extends StatelessWidget {
  const KidReport({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle baseText(double size, FontWeight weight) {
      return TextStyle(
        fontFamily: 'NanumS',
        fontWeight: weight,
        fontSize: size,
        color: Colors.black,
      );
    }
    return Scaffold(
      body: Container(
        width: 1000,
          height: 600,
          color: Colors.green[50],
          child: Column(
            children: [
              Text('김이안 학생', style: baseText(50, FontWeight.bold)),
              Text('단어 정확도', style: baseText(40, FontWeight.bold)),
              Text('조음별 현황', style: baseText(30, FontWeight.bold)),
              Container(height: 400 ,color: Colors.red,),
              Text('일자별 현황', style: baseText(30, FontWeight.bold)),
              Text('많이 연습한 단어', style: baseText(40, FontWeight.bold)),
              Text('전체 게임 현황', style: baseText(40, FontWeight.bold)),
            ],
          )),
    );
  }
}
