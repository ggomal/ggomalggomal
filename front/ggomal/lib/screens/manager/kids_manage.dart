import 'package:flutter/material.dart';

class KidsManageScreen extends StatelessWidget {
  const KidsManageScreen({super.key});

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
            ),
            Center(
              child: Wrap(
                spacing: 40,
                runSpacing: 20,
                children: ['박수빈', '장지민', '박서현', '최진우', '김창희']
                    .map(
                      (e) => Container(
                        width: 300.0,
                        height: 160.0,
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
                        child: Text(
                          e,
                          style: TextStyle(
                            fontFamily: 'NanumS',
                            fontWeight: FontWeight.w800,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
