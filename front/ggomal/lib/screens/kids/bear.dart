import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

class BearScreen extends StatelessWidget {
  const BearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bear/bear_bg.png'),
          fit: BoxFit.cover, // 화면에 꽉 차게
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: NavBar(),
        body: Stack(
          children: [
            Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Image.asset('assets/images/bear/window.png'),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Image.asset('assets/images/bear/mirror.png'),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Image.asset('assets/images/bear/chair1.png'),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Image.asset('assets/images/bear/chair2.png'),
                      ),
                      InkWell(
                        onTap: () {},
                        child: SizedBox(child: Image.asset('assets/images/bear/teacher.png'), width: 260,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 300, // 조정 가능, chair1과 chair2의 사이 중앙
              left: 160, // 조정 가능
              child: InkWell(
                onTap: () {},
                child: SizedBox(
                  width: 600,
                  child: Image.asset('assets/images/bear/table.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
