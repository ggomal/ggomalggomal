import 'package:flutter/material.dart';

class Notice extends StatelessWidget {
  final Map<String, dynamic> notice;

  const Notice(this.notice, {super.key});

  // {
  // "noticeId": 2,
  // "date": "2024-04-20",
  // "teacherName": "박서현",
  // "content": "오늘 몹시 즐거워하여 노래를 불렀습니다.",
  // "homeworks": [
  // {"homeworkContent": "개구리 게임 1회", "isDone": false},
  // ]
  // }

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


    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${notice['teacherName']} 선생님이 남긴 말", style: baseText(16, FontWeight.w900)),
                Text("${notice['content']}", style: baseText(14, FontWeight.normal)),
              ],
            ),
          ),

          SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("숙제", style: baseText(16, FontWeight.w900)),
                ...notice['homeworks']
                    .map(
                      (e) => Text("${e['homeworkContent']}", style: baseText(14, FontWeight.normal)),
                )
                    .toList(),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
