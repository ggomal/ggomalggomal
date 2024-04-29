import 'package:flutter/material.dart';

class KidCard extends StatelessWidget {
  final Map<String, dynamic> kidData;

  const KidCard(this.kidData);

  Widget textLine(Map<String, dynamic> text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "${text['field']}",
              style: TextStyle(
                fontFamily: 'NanumS',
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            "${text['data']}", style: TextStyle(
            fontFamily: 'NanumS',
            fontWeight: FontWeight.w800,
            fontSize: 14.0,
            color: Colors.black,
          ),
          ),
        ],
      ),
    );

    //   RichText(
    //   text: TextSpan(
    //     text: "${text['field']}  :  ",

    //     children: [
    //       TextSpan(
    //         text: "${text['data']}",
    //         style: TextStyle(
    //           fontWeight: FontWeight.w800,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 160.0,
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
        children: [
          {"field": "이름", "data": kidData["name"]},
          {"field": "나이", "data": kidData["age"]},
          {"field": "아이디", "data": kidData["id"]},
          {"field": "비밀번호", "data": kidData["password"]},
        ].map((e) => textLine(e)).toList(),
      ),
    );
  }
}
