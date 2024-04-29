import 'package:flutter/material.dart';
import 'package:ggomal/widgets/kid_card.dart';

class KidsManageScreen extends StatelessWidget {
  const KidsManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Padding(
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
              ),
              Center(
                child: Container(
                  width: 1000,
                  child: Wrap(
                    spacing: 40,
                    runSpacing: 20,
                    alignment: WrapAlignment.start,
                    children: [
                      Container(
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
                      ...[
                        {"name": "박수빈", "age" : 10, "id" : "subin", "password" : "subin123"},
                        {"name": "장지민", "age" : 10, "id" : "jm", "password" : "jm123"},
                        {"name": "김창희", "age" : 10, "id" : "ch", "password" : "ch123"},
                        {"name": "박서현", "age" : 10, "id" : "sh", "password" : "sh123"},
                        {"name": "최진우", "age" : 10, "id" : "jw", "password" : "jw123"},
                        {"name": "수빈공주", "age" : 10, "id" : "princess", "password" : "princess123 "},
                        {"name": "박수빈", "age" : 10, "id" : "subin", "password" : "subin123"},
                        {"name": "장지민", "age" : 10, "id" : "jm", "password" : "jm123"},
                        {"name": "김창희", "age" : 10, "id" : "ch", "password" : "ch123"},
                        {"name": "박서현", "age" : 10, "id" : "sh", "password" : "sh123"},
                        {"name": "최진우", "age" : 10, "id" : "jw", "password" : "jw123"},
                        {"name": "수빈공주", "age" : 10, "id" : "princess", "password" : "princess123 "},
                      ]
                          .map(
                            (e) => KidCard(e),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
