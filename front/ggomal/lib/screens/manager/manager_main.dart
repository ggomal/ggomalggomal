import 'package:flutter/material.dart';
import 'package:ggomal/services/kid_manage_dio.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/constants.dart';

import 'package:ggomal/login_storage.dart';
import '../../utils/navbar_manager.dart';

class ManagerMainScreen extends StatefulWidget {
  const ManagerMainScreen({super.key});

  @override
  State<ManagerMainScreen> createState() => _ManagerMainScreenState();
}

class _ManagerMainScreenState extends State<ManagerMainScreen> {
  String? name = '';
  List kidList = [
    {"memberId": 0, "name": "등록", "age": 0, "id": "2stu3IS1hhp", "password": "20240507"},
  ];

  getUserName() async {
    LoginStorage storage = await LoginStorage();
    String? loginName = await storage.getName();
    setState(() {
      name = loginName;
    });
  }

  getUserKidList() async {
    List kids = await getKidList();
    setState(() {
      kidList = kids;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    getUserKidList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF9F9F9),
        appBar: ManagerNavBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 10.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Image.asset(
              //   width: 250.0,
              //   'assets/images/logo.png',
              // ),
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
                      "$name 선생님 안녕하세요!",
                      style: nanumText(36.0, FontWeight.w900, Colors.white),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "담당 학생 목록이에요.",
                      style: nanumText(20.0, FontWeight.w700, Colors.white),
                    ),
                    SizedBox(
                      height: 80,
                      child: SingleChildScrollView(

                        child: Wrap(
                          children: kidList
                              .map(
                                (e) =>
                                Container(
                                  width: 130,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 3.0,
                                  ),
                                  margin: EdgeInsets.only(top: 5, right: 20),
                                  child: Text(
                                    "${e['name']}-${e['age']}세",
                                    style: nanumText(
                                        18.0, FontWeight.w800, Colors.black),
                                  ),
                                ),
                          )
                              .toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      context.go('/manager/calender');
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
