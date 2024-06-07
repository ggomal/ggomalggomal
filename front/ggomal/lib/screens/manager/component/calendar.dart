import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../const/color.dart';
import '../model/Schedule.dart';

class Calendar extends StatelessWidget {
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;
  final bool Function(DateTime day) selectedDayPredicate;
  final Map<DateTime, List<Schedule>> schedules;

  const Calendar({
    required this.focusedDay,
    required this.onDaySelected,
    required this.selectedDayPredicate,
    required this.schedules,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      border: Border.all(
        color: Colors.grey[200]!,
        width: 1.0,
      ),
    );

    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    List<Schedule> _getEventsForDay(DateTime day) {
      return schedules[day] ?? [];
    }

    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      eventLoader: _getEventsForDay,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return Container(
            margin: EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: defaultBoxDecoration,
            child: Text(
              day.day.toString(),
              style: defaultTextStyle,
            ),
          );
        },
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: 16.0,
                height: 16.0,
                decoration: BoxDecoration(
                  color: Color(0xFFFF6C33), // 마커 색상을 변경하려면 여기를 수정하세요.
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${events.length}',
                    style: TextStyle().copyWith(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            );
          }
          return null;
        },
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        defaultDecoration: defaultBoxDecoration,
        weekendDecoration: defaultBoxDecoration,
        selectedDecoration: defaultBoxDecoration.copyWith(
          border: Border.all(
            color: primaryColor,
            width: 1.0,
          ),
        ),
        todayDecoration: defaultBoxDecoration.copyWith(
          color: primaryColor,
        ),
        outsideDecoration: defaultBoxDecoration.copyWith(
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(
          color: primaryColor,
        ),
      ),
      onDaySelected: onDaySelected,
      selectedDayPredicate: selectedDayPredicate,
    );
  }
}
