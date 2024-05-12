import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class KidReport extends StatefulWidget {
  const KidReport({super.key});

  @override
  State<KidReport> createState() => _KidReportState();
}

class _KidReportState extends State<KidReport> {
  String? selectedWord = "ㄱ, ㅋ";

  // 단어 리스트로 바꾸기 !

  List<String> wordList = ["ㄱ, ㅋ", "ㄴ", "ㄷ, ㅌ", "ㄹ", "ㅁ"];

  Map reportData = {
    "wordAccuracyMean": {
      "ㅁ": 0.825148,
      "ㄱ, ㅋ": 3.22583,
      "ㄴ": 3.22583,
      "ㄷ, ㅌ": 3.22583,
      "ㄹ": 3.22583
    },
    "wordAccuracy": {
      "ㅁ": [
        {"date": "2024-05-07", "accuracyMean": 0.712574},
        {"date": "2024-05-09", "accuracyMean": 0.937722}
      ],
      "ㄱ, ㅋ": [
        {"date": "2024-05-06", "accuracyMean": 3.93264},
        {"date": "2024-05-07", "accuracyMean": 2.51902}
      ],
      "ㄴ": [
        {"date": "2024-05-06", "accuracyMean": 3.93264},
        {"date": "2024-05-07", "accuracyMean": 2.51902}
      ],
      "ㄷ, ㅌ": [
        {"date": "2024-05-06", "accuracyMean": 3.93264},
        {"date": "2024-05-07", "accuracyMean": 2.51902}
      ],
      "ㄹ": [
        {"date": "2024-05-06", "accuracyMean": 3.93264},
        {"date": "2024-05-07", "accuracyMean": 2.51902}
      ],
    },
    "whaleMaxTime": [
      {"date": "2024-05-09", "meanMaxTime": 2.3},
      {"date": "2024-05-10", "meanMaxTime": 7.25},
      {"date": "2024-05-11", "meanMaxTime": 4.25},
      {"date": "2024-05-12", "meanMaxTime": 1.25},
      {"date": "2024-05-13", "meanMaxTime": 2.25}
    ],
    "mostUsedWord": ["String", "String", "String"],
    "chickAccuracy": [
      {"date": "2024-05-04", "meanMaxTime": 2.3},
      {"date": "2024-05-05", "meanMaxTime": 2.3},
      {"date": "2024-05-08", "meanMaxTime": 2.3},
      {"date": "2024-05-09", "meanMaxTime": 2.3},
      {"date": "2024-05-11", "meanMaxTime": 4.25},
      {"date": "2024-05-12", "meanMaxTime": 1.25},
      {"date": "2024-05-13", "meanMaxTime": 2.25}
    ]
  };

  Container graphBox(Widget graph) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 300,
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
      child: graph,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<MeanData> wordMeanData = wordList
        .map((e) => MeanData(e, reportData['wordAccuracyMean'][e]))
        .toList();

    List<TimeData> wordData = [
      ...reportData['wordAccuracy'][selectedWord]
          .map((e) => TimeData(e['date'], e['accuracyMean']))
          .toList()
    ];

    List<TimeData> whaleData = [
      ...reportData['whaleMaxTime']
          .map((e) => TimeData(e['date'], e['meanMaxTime']))
          .toList()
    ];

    List<TimeData> chickData = [
      ...reportData['chickAccuracy']
          .map((e) => TimeData(e['date'], e['meanMaxTime']))
          .toList()
    ];

    wordData =
        wordData.length < 5 ? wordData : wordData.sublist(wordData.length - 5);
    whaleData = whaleData.length < 5
        ? whaleData
        : whaleData.sublist(whaleData.length - 5);
    chickData = chickData.length < 5
        ? chickData
        : chickData.sublist(chickData.length - 5);

    return Container(
      color: Colors.white,
      child: ListView(scrollDirection: Axis.vertical, children: [
        Column(
          children: [
            graphBox(
              Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 10,
                    child: Container(
                      width: 100,
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFF706F6F),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: DropdownButton(
                        value: selectedWord,
                        items: wordList
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedWord = value;
                          });
                        },
                        style: nanumText(14, FontWeight.w700, Colors.black),
                        dropdownColor: Colors.white,
                        underline: Container(),
                        isExpanded: true,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text('단어 정확도(일자별)',
                          style: nanumText(24, FontWeight.w900, Colors.black)),
                      SizedBox(
                        width: double.infinity,
                        height: 220,
                        child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            series: <CartesianSeries>[
                              LineSeries<TimeData, String>(
                                  dataSource: wordData,
                                  xValueMapper: (TimeData word, _) => word.day,
                                  yValueMapper: (TimeData word, _) => word.data)
                            ]),
                      )
                    ],
                  ),
                ],
              ),
            ),
            graphBox(
              Column(
                children: [
                  Text('단어 정확도(평균)',
                      style: nanumText(24, FontWeight.w900, Colors.black)),
                  SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis:
                            NumericAxis(minimum: 0, maximum: 5),
                        series: <CartesianSeries<MeanData, String>>[
                          ColumnSeries<MeanData, String>(
                              dataSource: wordMeanData,
                              xValueMapper: (MeanData data, _) => data.word,
                              yValueMapper: (MeanData data, _) => data.data,
                              color: Color(0xFFFF9191))
                        ]),
                  )
                ],
              ),
            ),
            graphBox(
              Column(
                children: [
                  Text('발성 연습(고래 게임)',
                      style: nanumText(24, FontWeight.w900, Colors.black)),
                  SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          LineSeries<TimeData, String>(
                              dataSource: whaleData,
                              xValueMapper: (TimeData whale, _) => whale.day,
                              yValueMapper: (TimeData whale, _) => whale.data)
                        ]),
                  )
                ],
              ),
            ),
            graphBox(
              Column(
                children: [
                  Text('병아리 게임 발음 점수',
                      style: nanumText(24, FontWeight.w900, Colors.black)),
                  SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          LineSeries<TimeData, String>(
                              dataSource: chickData,
                              xValueMapper: (TimeData chick, _) => chick.day,
                              yValueMapper: (TimeData chick, _) => chick.data)
                        ]),
                  )
                ],
              ),
            ),
            graphBox( Column(
                children: [
                  Text('많이 연습한 단어',
                      style: nanumText(24, FontWeight.w900, Colors.black)),
                  SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: Column(
                        children: [
                          ...reportData['mostUsedWord']
                              .map((e) => Text(e,
                                  style: nanumText(
                                      30, FontWeight.w900, Colors.black)))
                              .toList()
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class TimeData {
  TimeData(this.day, this.data);

  final String day;
  final double data;
}

class MeanData {
  MeanData(this.word, this.data);

  final String word;
  final double data;
}
