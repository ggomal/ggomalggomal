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
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constants.dart';
import '../../services/dio.dart';
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

  Map<DateTime, List<Schedule>> schedules = {};

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  void fetchSchedules() async {
    var dio = await useDio();
    var response = await dio.get('/schedule?kidId=4&year=2024&month=5');
    var data = response.data as List;

    Map<DateTime, List<Schedule>> newSchedules = {};

    for (var item in data) {
      DateTime startTime = DateTime.parse(item['startTime']);
      DateTime endTime = DateTime.parse(item['endTime']);
      Schedule schedule = Schedule(
        id: item['kidId'], // 임시로 kidId를 id로 사용
        startTime: startTime.hour,
        endTime: endTime.hour, // 예시로 1시간 후를 종료 시간으로 설정
        content: item['content'],
        date: DateTime.utc(startTime.year, startTime.month, startTime.day),
        color: categoryColors[0], // 임의로 색상 설정
        createdAt: DateTime.now().toUtc(),
      );

      if (!newSchedules.containsKey(schedule.date)) {
        newSchedules[schedule.date] = [];
      }
      newSchedules[schedule.date]!.add(schedule);
    }

    setState(() {
      schedules = newSchedules;
    });
  }

  List<Schedule> _getEventsForDay(DateTime day) {
    return schedules[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: ManagerNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: ScheduleBottomSheet(
                    selectedDay: selectedDay,
                    fetchSchedules: fetchSchedules,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                );
              }
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                height: 50.0,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.go('/manager');
                      },
                      child: Row(
                        children: [
                          Icon(Icons.navigate_before, color: Colors.black, size: 50,),
                          Text(
                            "홈으로",
                            style: nanumText(30.0, FontWeight.w700, Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.55,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Calendar(
                        focusedDay: DateTime(2024, 5, 1),
                        onDaySelected: onDaySelected,
                        selectedDayPredicate: selectedDayPredicate,
                        schedules: schedules,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!, width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          TodayBanner(
                            selectedDay: selectedDay,
                            taskCount: schedules[selectedDay]?.length ?? 0,
                          ),
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
                                    color: Color(int.parse('FF${scheduleModel.color}', radix: 16)),
                                  );
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
    return date.isAtSameMomentAs(selectedDay);
  }
}
