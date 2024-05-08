import 'package:flutter/material.dart';
import 'package:ggomal/services/kid_manage_dio.dart';
import 'package:ggomal/widgets/kid_content.dart';
import 'package:ggomal/widgets/kid_info.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/constants.dart';

class KidDetail extends StatefulWidget {
  final String? kidId;

  const KidDetail(this.kidId, {super.key});

  @override
  State<KidDetail> createState() => _KidDetailState();
}

class _KidDetailState extends State<KidDetail> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              padding: const EdgeInsets.symmetric(horizontal: 100),
              height: 50.0,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.go('/manager/kids');
                    },
                    child: Text(
                      "< 아이 목록",
                      style: nanumText(30.0, FontWeight.w700, Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: 1000.0,
                height: 450.0,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      blurRadius: 5.0,
                      offset: Offset(3, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(children: [
                  KidInfo(widget.kidId),
                  SizedBox(
                    width: 20,
                  ),
                  KidContent(widget.kidId),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
