import 'package:flutter/material.dart';
import 'package:ggomal/services/kid_manage_dio.dart';
import 'package:ggomal/widgets/check.dart';
import 'package:ggomal/widgets/enroll_kid.dart';
import 'package:ggomal/widgets/kid_card.dart';

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

    GestureDetector enrollButton () {
      return GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => EnrollKidModal(),
        ).then((response) => {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                CheckModal(response),
          ).then((value) => {
            setState((){

              _kidListFuture = getKidList();
            })
          }),
        }),
        child: Container(
          width: 300.0,
          height: 160.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                blurRadius: 5.0,
                offset:
                Offset(3, 3), // changes position of shadow
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
              width: 250.0,
              'assets/images/logo.png',
            ),
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: SizedBox(
                width: 1000,
                child: FutureBuilder<List<dynamic>>(
                  future: _kidListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('학생 정보 로딩 실패');
                    } else {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom:100),
                        child: Wrap(
                          spacing: 40,
                          runSpacing: 20,
                          children: [enrollButton(),
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
