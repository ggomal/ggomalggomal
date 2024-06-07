// 공통 설정 / 속성 정의
import 'package:flutter/material.dart';

TextStyle nanumText(double size, FontWeight weight, Color color) {
  return TextStyle(
    fontFamily: 'NanumS',
    fontWeight: weight,
    fontSize: size,
    color: color,
  );
}

TextStyle mapleText(double size, FontWeight weight, Color color) {
  return TextStyle(
    fontFamily: 'Maplestory',
    fontWeight: weight,
    fontSize: size,
    color: color,
  );
}

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}
