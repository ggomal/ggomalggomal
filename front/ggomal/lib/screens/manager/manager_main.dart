import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/constants.dart';

class ManagerMainScreen extends StatelessWidget {
  const ManagerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF9F9F9),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 10.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                width: 250.0,
                'assets/images/logo.png',
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xFFFF956B),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 10.0,
                ),
                margin: const EdgeInsets.only(bottom: 30.0),
                width: 1000.0,
                height: 250.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "위재원 선생님 안녕하세요!",
                      style: nanumText(36.0, FontWeight.w900, Colors.white),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "담당 학생 목록이에요.",
                      style: nanumText(20.0, FontWeight.w700, Colors.white),

                    ),
                    Wrap(
                      children: ['박수빈', '장지민', '박서현', '최진우', '김창희']
                          .map(
                            (e) => Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 3.0,
                              ),
                              margin: EdgeInsets.only(top: 5, right: 20),
                              child: Text(
                                e,
                                style: nanumText(18.0, FontWeight.w800, Colors.black),
                              ),
                            ),
                          )
                          .toList(),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // context.go('/manager/schedule');
                    },
                    child: SizedBox(
                      width: 500.0,
                      child: Image.asset(
                          'assets/images/manager/schedule_manage_button.png'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.go('/manager/kids');
                    },
                    child: SizedBox(
                      width: 500.0,
                      child: Image.asset(
                          'assets/images/manager/kids_manage_button.png'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
