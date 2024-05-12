import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ggomal/screens/manager/component/calendar.dart';
import 'package:ggomal/screens/manager/component/custom_text_field.dart';
import 'package:ggomal/screens/manager/component/schedule_bottom_sheet.dart';
import 'package:ggomal/screens/manager/component/schedule_card.dart';
import 'package:ggomal/screens/manager/component/today_banner.dart';
import 'package:ggomal/screens/manager/const/color.dart';
import 'package:ggomal/screens/manager/model/Schedule.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/navbar_manager.dart';

class ManagerCalendarScreen extends StatefulWidget {
  const ManagerCalendarScreen({super.key});

  @override
  State<ManagerCalendarScreen> createState() => _ManagerCalendarScreenState();
}

class _ManagerCalendarScreenState extends State<ManagerCalendarScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<Schedule>> schedules = {
    DateTime.utc(2024, 5, 8): [
      Schedule(
        id: 1,
        startTime: 11,
        endTime: 12,
        content: '플러터 공부하기',
        date: DateTime.utc(2024, 5, 8),
        color: categoryColors[0],
        createdAt: DateTime.now().toUtc(),
      ),
      Schedule(
        id: 2,
        startTime: 14,
        endTime: 16,
        content: 'NestJS 공부하기',
        date: DateTime.utc(2024, 5, 8),
        color: categoryColors[3],
        createdAt: DateTime.now().toUtc(),
      ),
    ],
    DateTime.utc(2024, 5, 10): [
      Schedule(
        id: 1,
        startTime: 11,
        endTime: 12,
        content: '플러터 공부하기',
        date: DateTime.utc(2024, 5, 8),
        color: categoryColors[0],
        createdAt: DateTime.now().toUtc(),
      ),
      Schedule(
        id: 2,
        startTime: 14,
        endTime: 16,
        content: 'NestJS 공부하기',
        date: DateTime.utc(2024, 5, 8),
        color: categoryColors[3],
        createdAt: DateTime.now().toUtc(),
      ),
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: ManagerNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return ScheduleBottomSheet();
              });
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Center( // Center를 사용해 전체를 중앙에 배치
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 세로 방향 중앙 정렬
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 가로 방향 간격 조정
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.55,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!, width: 1),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Calendar(
                          focusedDay: DateTime(2024, 5, 1),
                          onDaySelected: onDaySelected,
                          selectedDayPredicate: selectedDayPredicate),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4, //
                      height: MediaQuery.of(context).size.height * 0.7,//
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!, width: 1),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        children: [
                          TodayBanner(selectedDay: selectedDay, taskCount: 0),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                              child: ListView.separated(
                                itemCount: schedules.containsKey(selectedDay) ? schedules[selectedDay]!.length : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  final scheduleSchedules = schedules[selectedDay]!;
                                  final scheduleModel = scheduleSchedules[index];
                                  return ScheduleCard(
                                      startTime: scheduleModel.startTime,
                                      endTime: scheduleModel.endTime,
                                      content: scheduleModel.content,
                                      color: Color(int.parse('FF${scheduleModel.color}', radix: 16)));
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(height: 8.0);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
    });
  }

  bool selectedDayPredicate(DateTime date) {
    if (selectedDay == null) return false;

    return date.isAtSameMomentAs(selectedDay!);
  }
}
