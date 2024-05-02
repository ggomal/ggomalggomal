import 'package:flutter/material.dart';
import 'package:ggomal/widgets/kid_content.dart';
import 'package:ggomal/widgets/kid_info.dart';
import 'package:go_router/go_router.dart';

class KidDetail extends StatefulWidget {
  const KidDetail(this.id, {super.key});

  final String? id;

  @override
  State<KidDetail> createState() => _KidDetailState();
}

class _KidDetailState extends State<KidDetail> {
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
            SizedBox(
              height: 50.0,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.go('/manager/kids');
                    },
                    child: Text(
                      "< 아이 목록",
                      style: TextStyle(
                        fontFamily: "NanumS",
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                      ),
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
                  KidInfo(),
                  SizedBox(width: 20,),
                  KidContent(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
