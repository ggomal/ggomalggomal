import 'package:flutter/material.dart';
import 'package:ggomal/widgets/notice.dart';

class KidNote extends StatelessWidget {
  const KidNote({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> noticeList = [
      {
        "noticeId": 1,
        "date": "2024-04-13",
        "teacherName": "장지민",
        "content": "오늘 몹시 즐거워하여 춤을 추었습니다.",
        "homeworks": [
          {"homeworkContent": "개구리 게임 2회", "isDone": false},
        ]
      },
      {
        "noticeId": 2,
        "date": "2024-04-20",
        "teacherName": "박서현",
        "content": "오늘 몹시 즐거워하여 노래를 불렀습니다.",
        "homeworks": [
          {"homeworkContent": "개구리 게임 1회", "isDone": false},
        ]
      },
      {
        "noticeId": 3,
        "date": "2024-04-20",
        "teacherName": "위재원",
        "content": "오늘 몹시 즐거워하여 노래를 불렀습니다.",
        "homeworks": [
          {"homeworkContent": "개구리 게임 1회", "isDone": false},
        ]
      },{
        "noticeId": 4,
        "date": "2024-04-20",
        "teacherName": "김창희",
        "content": "오늘 몹시 즐거워하여 노래를 불렀습니다.",
        "homeworks": [
          {"homeworkContent": "개구리 게임 1회", "isDone": false},
        ]
      },{
        "noticeId": 2,
        "date": "2024-04-20",
        "teacherName": "박수빈",
        "content": "오늘 몹시 즐거워하여 노래를 불렀습니다.",
        "homeworks": [
          {"homeworkContent": "개구리 게임 1회", "isDone": false},
        ]
      },{
        "noticeId": 2,
        "date": "2024-04-20",
        "teacherName": "최진우",
        "content": "오늘 몹시 즐거워하여 노래를 불렀습니다.",
        "homeworks": [
          {"homeworkContent": "개구리 게임 1회", "isDone": false},
        ]
      }
    ];

    return

        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    "assets/images/manager/add_button.png",
                    width: 40,
                  )
                ]
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: noticeList.map((e) => Notice(e)).toList(),


                  ),
            ),
          ],
        );
  }
}
