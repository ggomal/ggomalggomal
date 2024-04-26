import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/utils/navbar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double dynamicWidth = MediaQuery.of(context).size.width * 0.23;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/main.png'),
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
                Container(
                  padding: EdgeInsets.fromLTRB(
                      dynamicWidth * 0.3, dynamicWidth*0.3, dynamicWidth * 0.3, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          context.go('/kids/chick');
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/chick_house.png'),
                          width: dynamicWidth,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.go('/kids/bear');
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/bear_house.png'),
                          width: dynamicWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: Image.asset('assets/images/frog_house.png'),
                        width: dynamicWidth,
                      ),
                      InkWell(
                        onTap: () {
                          context.go('/kids/whale');
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/whale_house.png'),
                          width: dynamicWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: InkWell(
                onTap: () {
                  context.go('/kids/home');
                },
                child: SizedBox(
                  width: dynamicWidth * 0.8,
                  child: Image.asset('assets/images/girl.png'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
