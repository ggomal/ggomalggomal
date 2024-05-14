import 'package:flutter/material.dart';

import '../const/color.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;
  final int taskCount;

  const TodayBanner({
    required this.selectedDay,
    required this.taskCount,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
            color: primaryColor,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[400]!,
                width: 1,
              ),
            ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
          )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                ),
              ),
              // Text(
              //   '${taskCount}개',
              //   style: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w700
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
