import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/kid_manage_dio.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import "package:flutter_podium/flutter_podium.dart";

class KidReport extends StatefulWidget {
  final String? kidId;

  const KidReport(this.kidId, {super.key});

  @override
  State<KidReport> createState() => _KidReportState();
}

class _KidReportState extends State<KidReport> {
  Map<String, dynamic> reportData = {};
  List<TimeData> wordData = [];
  List<TimeData> whaleData = [];
  List<TimeData> chickData = [];
  List<MeanData> wordMeanData = [];
  List<dynamic> mostUsedWord = [
    {"word": "", "count": 0},
    {"word": "", "count": 0},
    {"word": "", "count": 0},
  ];

  @override
  void initState() {
    super.initState();
    loadReportData();
  }

  String? selectedWord = "ㄱ, ㅋ, ㅈ, ㅊ";
  List<String> wordList = ["ㄱ, ㅋ, ㅈ, ㅊ", "ㄷ, ㅌ, ㄴ", "ㅍ, ㅁ, ㅇ", "ㅅ", "ㄹ"];
  // ['ㅍ,ㅁ,ㅇ', 'ㄷ,ㅌ,ㄴ', 'ㄱ,ㅋ,ㅈ,ㅊ', 'ㅅ', 'ㄹ']
  Future<void> loadReportData() async {
    reportData = await getStatistics(widget.kidId as String);
    print(reportData);
    wordMeanData = wordList
        .map((e) => MeanData(e, reportData['wordAccuracyMean'][e]))
        .toList();
    wordData = [
      ...reportData['wordAccuracy'][selectedWord]
          .map((e) => TimeData(e['date'], e['accuracyMean']))
          .toList()
    ];
    whaleData = [
      ...reportData['whaleMaxTime']
          .map((e) => TimeData(e['date'], e['meanMaxTime']))
          .toList()
    ];
    chickData = [
      ...reportData['chickAccuracy']
          .map((e) => TimeData(e['date'], e['accuracyMean']))
          .toList()
    ];
    setState(() {
      wordData = wordData.length < 5 ? wordData : wordData.sublist(wordData.length - 5);
      whaleData = whaleData.length < 5 ? whaleData : whaleData.sublist(whaleData.length - 5);
      chickData = chickData.length < 5 ? chickData : chickData.sublist(chickData.length - 5);

      mostUsedWord = reportData['mostUsedWord'];

      if (mostUsedWord.length < 3){
        mostUsedWord.add({"word": "경찰차", "count": 0});
        mostUsedWord.add({"word": "가방", "count": 0});
        mostUsedWord.add({"word": "가로등", "count": 0});
      }
    });
  }

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
                      width: 130,
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
                            wordData = [
                              ...reportData['wordAccuracy'][value]
                                  .map((e) => TimeData(e['date'], e['accuracyMean']))
                                  .toList()
                            ];
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
                      Text('일자별 단어 정확도',
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
                  Text('단어 정확도 평균 ',
                      style: nanumText(24, FontWeight.w900, Colors.black)),
                  SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(minimum: 0, maximum: 100),
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
                  Text('고래 게임 모음 연습',
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
            graphBox(
              Column(
                children: [
                  Text('많이 연습한 단어',
                      style: nanumText(24, FontWeight.w900, Colors.black)),
                  Container(
                      width: double.infinity,
                      height: 220,
                      padding: const EdgeInsets.all(30),
                      child: Podium(
                        height: 100,
                        width: 100,
                        color: Color(0xFFFF9191),
                        horizontalSpacing: 50,
                        hideRanking: true,
                        firstPosition: Text(
                          "${mostUsedWord[0]['word']} / ${mostUsedWord[0]['count']}회",
                        ),
                        secondPosition: Text(
                          "${mostUsedWord[1]['word']} / ${mostUsedWord[1]['count']}회",
                        ),
                        thirdPosition: Text(
                          "${mostUsedWord[2]['word']} / ${mostUsedWord[2]['count']}회",
                        ),
                      ),
                  ),
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

  final String? day;
  final double? data;
}

class MeanData {
  MeanData(this.word, this.data);

  final String? word;
  final double? data;
}
