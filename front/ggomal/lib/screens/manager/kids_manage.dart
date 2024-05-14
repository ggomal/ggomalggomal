import 'package:flutter/material.dart';
import 'package:ggomal/services/kid_manage_dio.dart';
import 'package:ggomal/widgets/check.dart';
import 'package:ggomal/widgets/enroll_kid.dart';
import 'package:ggomal/widgets/kid_card.dart';
import 'package:go_router/go_router.dart';
import '../../constants.dart';

class KidsManageScreen extends StatefulWidget {
  const KidsManageScreen({super.key});

  @override
  State<KidsManageScreen> createState() => _KidsManageScreenState();
}

class _KidsManageScreenState extends State<KidsManageScreen> {
  late Future<List> _kidListFuture;

  @override
  void initState() {
    super.initState();
    _kidListFuture = getKidList();
  }

  @override
  Widget build(BuildContext context) {
    double width = screenSize(context).width;
    double height = screenSize(context).height;

    GestureDetector enrollButton() {
      return GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => EnrollKidModal(),
        ).then((response) => {
              showDialog(
                context: context,
                builder: (BuildContext context) => CheckModal(response),
              ).then((value) => {
                    setState(() {
                      _kidListFuture = getKidList();
                    })
                  }),
            }),
        child: Container(
          width: width * 0.25,
          height: height * 0.2,
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
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Image.asset(
              'assets/images/manager/enroll_button.png',
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              width: width * 0.25,
              'assets/images/logo.png',
            ),
            GestureDetector(
              onTap: () {
                context.go('/manager/kids');
              },
              child: Container(
                margin: EdgeInsets.only(left: 100, bottom: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.navigate_before,
                      color: Colors.black,
                      size: 50,
                    ),
                    Text(
                      "홈으로",
                      style: nanumText(30.0, FontWeight.w700, Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: width * 0.8,
                child: FutureBuilder<List<dynamic>>(
                  future: _kidListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('학생 정보 로딩 실패');
                    } else {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Wrap(
                          spacing: 40,
                          runSpacing: 20,
                          children: [
                            enrollButton(),
                            ...List.generate(
                              snapshot.data!.length,
                              (index) => KidCard(snapshot.data![index]),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
