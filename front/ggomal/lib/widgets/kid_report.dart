import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class KidReport extends StatefulWidget {
  const KidReport({super.key});

  @override
  State<KidReport> createState() => _KidReportState();
}

class _KidReportState extends State<KidReport> {
  Map reportData = {
    "wordAccuracyMean": {
      "ㅁ": 0.825148,
      "ㄱ, ㅋ": 3.22583
    },
    "wordAccuracy": {
      "ㅁ": [
        {
          "date": "2024-05-07",
          "accuracyMean": 0.712574
        },
        {
          "date": "2024-05-09",
          "accuracyMean": 0.937722
        }
      ],
      "ㄱ, ㅋ": [
        {
          "date": "2024-05-06",
          "accuracyMean": 3.93264
        },
        {
          "date": "2024-05-07",
          "accuracyMean": 2.51902
        }
      ]
    },
    "whaleMaxTime": [
      {
        "date": "2024-05-09",
        "meanMaxTime": 2.3
      },
      {
        "date": "2024-05-10",
        "meanMaxTime": 3.25
      }
    ],
    "mostUsedWord": ["String", "String", "String"],
    "chickAccuracy": [
      {
        "date": "2024-05-09",
        "meanMaxTime": 2.3
      },
      {
        "date": "2024-05-09",
        "meanMaxTime": 2.3
      }
    ]
  };


  @override
  Widget build(BuildContext context) {

    List<FlSpot> sleepdata = <FlSpot>[
      FlSpot(0, 7),
      FlSpot(1, 6),
      FlSpot(2, 6),
      FlSpot(3, 8),
      FlSpot(4, 5),
      FlSpot(5, 8),
      FlSpot(6, 9),
    ];


    return Container(
      color: Colors.white,
      child: ListView(scrollDirection: Axis.vertical, children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: Column(
                children: [
                  Text('단어 정확도(일자별)',
                      style: nanumText(24, FontWeight.w900, Colors.black)),
                  SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: LineChart(
                      LineChartData(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: Text('단어 정확도(평균)',
                  style: nanumText(24, FontWeight.w900, Colors.black)),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: Text('발성 연습(고래 게임)',
                  style: nanumText(24, FontWeight.w900, Colors.black)),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: Text('병아리 게임 발음 점수',
                  style: nanumText(24, FontWeight.w900, Colors.black)),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 300,
              color: Colors.grey[200],
              child: Text('많이 사용한 단어',
                  style: nanumText(24, FontWeight.w900, Colors.black)),
            ),
          ],
        ),
      ]),
    );
  }
}
