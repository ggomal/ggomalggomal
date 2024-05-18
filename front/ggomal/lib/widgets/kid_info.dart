import 'package:flutter/material.dart';
import 'package:ggomal/services/kid_manage_dio.dart';
import 'package:ggomal/screens/manager/create_bingo.dart';
import 'package:ggomal/constants.dart';
import 'package:go_router/go_router.dart';

class KidInfo extends StatefulWidget {
  final String? kidId;

  const KidInfo(this.kidId, {super.key});

  @override
  State<KidInfo> createState() => _KidInfoState();
}

class _KidInfoState extends State<KidInfo> {
  late Future<dynamic> _kidFuture;

  @override
  void initState() {
    super.initState();
    if (widget.kidId != null) {
      _kidFuture = getKid(widget.kidId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = screenSize(context).width;
    double height = screenSize(context).height;
    double textSize = width > 1500 ? 18.0 : 14.0;
    Widget textLine(Map<String, String> text) {


      return Flexible(
        flex: 1,
        child: SizedBox(
          height: height * 0.05,
          child: Row(
            children: [
              SizedBox(
                width: width * 0.07,
                child: Text(
                  "${text['field']}",
                  style: nanumText(textSize, FontWeight.w800, Colors.black),
                ),

              ),
              Text(
                "${text['data']}",
                style: nanumText(textSize, FontWeight.w500, Colors.black),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 20,
      ),
      width: width * 0.2,
      height: height * 0.6,
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
      child: FutureBuilder(
        future: _kidFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: 50,
              height: 50,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Text('데이터 로딩 실패');
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset(
                    snapshot.data!['gender'] == 'MALE' ? "assets/images/manager/photo_boy.png" : "assets/images/manager/photo_girl.png",
                    width: width * 0.18,
                    height: height * 0.18,
                    fit: BoxFit.cover,
                  ),
                ),
                ...[
                  {"field": "이름", "data": "${snapshot.data!["name"]}"},
                  {"field": "나이", "data": "만 ${snapshot.data!["age"]}세"},
                  {"field": "아이디", "data": "${snapshot.data!["id"]}"},
                  {"field": "비밀번호", "data": "${snapshot.data!["password"]}"},
                  {
                    "field": "보호자 연락처",
                    "data": "${snapshot.data!["parentPhone"]}"
                  },
                ].map((e) => textLine(e)),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    "아이 특이사항",
                    style: nanumText(textSize, FontWeight.w800, Colors.black),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Text(
                    "${snapshot.data!['kidNote']}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: nanumText(textSize, FontWeight.w500, Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = snapshot.data!["name"];
                    final kidId = snapshot.data!["kidId"];
                    final memberId = snapshot.data!["memberId"];

                    GoRouter.of(context).go(
                        '/manager/bingo/$memberId',
                        extra: {'name': name, 'memberId': memberId}
                    );
                  },
                  child: Text("아이와 게임하기"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFAA8D),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
