import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:ggomal/services/dio.dart';
import 'package:audioplayers/audioplayers.dart';

import '../models/kids_checklist_modal.dart';

class NotificationDialog extends StatefulWidget {
  const NotificationDialog({super.key});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  List<ChecklistItem> items = [];
  String teacherComment = '';
  String teacherName = '';

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchNoticeData();
  }

  Future<void> _fetchNoticeData() async {
    try {
      Dio dio = await useDio();
      final response = await dio.get(
        '/notice',
        queryParameters: {
          'year': selectedDate.year,
          'month': selectedDate.month,
          'day': selectedDate.day,
        },
      );

      final data = response.data;
      setState(() {
        teacherComment = data['content'] ?? '선생님의 말 없음';
        teacherName = data['teacherName'] ?? '알 수 없음';
        items = (data['homeworks'] as List).map((homework) {
          return ChecklistItem(
            content: homework['homeworkContents'] ?? '내용 없음',
            isChecked: homework['isDone'] ?? false,
            state: (homework['isDone'] ?? false) ? CheckListState.SUCCESS : CheckListState.FAIL,
          );
        }).toList();
      });
    } catch (e) {
      print("Failed to fetch notice data: $e");
      setState(() {
        // 데이터 가져오기 실패 시 목록 초기화
        teacherComment = '';
        teacherName = '';
        items = [];
      });
    }
  }

  void _changeDate(bool forward) {
    setState(() {
      selectedDate = forward
          ? selectedDate.add(Duration(days: 1))
          : selectedDate.subtract(Duration(days: 1));
      _fetchNoticeData();  // 날짜가 바뀔 때마다 데이터를 다시 가져옵니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.5;
    double height = screenSize.height * 0.8;
    final AudioPlayer player = AudioPlayer();
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/home/notification_modal.png"),
              fit: BoxFit.fill,
            )),
        child: Container(
          padding: EdgeInsets.all(10.0),
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 50,
                            ),
                            color: Colors.black,
                            onPressed: () {
                              player.play(AssetSource('audio/touch.mp3'));
                                  _changeDate(false);
                            }
                          ))),
                  Flexible(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
                          style: TextStyle(
                              fontFamily: 'Maplestory',
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      )),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: Alignment.bottomLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 50,
                              ),
                              color: Colors.black,
                              onPressed: () {
                                player.play(AssetSource('audio/touch.mp3'));
                                    _changeDate(true);
                              }
                            )),
                        Container(
                            alignment: Alignment.bottomLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                size: 70,
                              ),
                              color: Colors.black,
                              onPressed: () {player.play(AssetSource('audio/touch.mp3'));
                                Navigator.of(context).pop();}
                            ))
                      ],
                    ),
                  ),
                ],
              ),
              Divider(height: 20),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(20),
                              height: 300,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset("assets/images/home/tone.png", width: 60,),
                                      Container(child: Text("선생님 한마디 ",
                                          style: TextStyle(
                                              fontFamily: 'Maplestory',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30
                                          )))
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text("$teacherName: $teacherComment",
                                      style: TextStyle(
                                          fontFamily: 'Maplestory',
                                          fontSize: 24
                                      ),
                                    ),)
                                ],
                              )
                          ),
                          Divider(height: 20),
                          Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset("assets/images/home/ttwo.png", width: 60,),
                                      Container(child: Text("오늘의 숙제",
                                          style: TextStyle(
                                              fontFamily: 'Maplestory',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30
                                          )))
                                    ],
                                  ),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      height: 400,
                                      child: ListView(
                                        children: items.map((item) {
                                          return Row(
                                            children: [
                                              Checkbox(
                                                fillColor: MaterialStateProperty.all(Colors.grey), // Use your Palette.appColor here
                                                value: item.isChecked,
                                                onChanged: (value) {
                                                  setState(() {
                                                    item.isChecked = value!;
                                                    item.state = item.isChecked ? CheckListState.SUCCESS : CheckListState.FAIL;
                                                  });
                                                },
                                              ),
                                              Text(
                                                item.content,
                                                style: TextStyle(
                                                  fontFamily: 'Maplestory',
                                                  fontSize: 24,
                                                  height: 1.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ))
                                ],
                              )
                          ),
                        ],
                      )
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class ChecklistItem {
  String content;
  bool isChecked;
  CheckListState state;

  ChecklistItem({
    required this.content,
    this.isChecked = false,
    this.state = CheckListState.FAIL,
  });
}

enum CheckListState {
  SUCCESS,
  FAIL,
}
