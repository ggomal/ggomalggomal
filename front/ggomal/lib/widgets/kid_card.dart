import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/constants.dart';

class KidCard extends StatelessWidget {
  final Map<String, dynamic> kidData;

  const KidCard(this.kidData, {super.key});

  Widget textLine(Map<String, dynamic> text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "${text['field']}",
              style: nanumText(18.0, FontWeight.w500, Colors.black),
            ),
          ),
          Text(
            "${text['data']}",
            style: nanumText(18.0, FontWeight.w700, Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double width = screenSize(context).width;
    double height = screenSize(context).height;

    return GestureDetector(
      onTap: () {
        context.go('/manager/kids/${kidData['memberId']}');
      },
      child: Container(
        width: width * 0.25,
        height: height * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 5.0,
              offset: Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            {"field": "이름", "data": kidData["name"]},
            {"field": "나이", "data": kidData["age"]},
            {"field": "아이디", "data": kidData["id"]},
            {"field": "비밀번호", "data": kidData["password"]},
          ].map((e) => textLine(e)).toList(),
        ),
      ),
    );
  }
}
