import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:ggomal/screens/kids/bear.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.fromLTRB(100, 30, 100, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Image.asset('assets/images/chick_house.png'),
                        width: 350,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BearScreen()),
                          );
                        },
                        child: SizedBox(
                          child: Image.asset('assets/images/bear_house.png'),
                          width: 350,
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
                        width: 350,
                      ),
                      SizedBox(
                        child: Image.asset('assets/images/whale_house.png'),
                        width: 350,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: SizedBox(child:Image.asset('assets/images/girl.png'), width: 200,),
            ),
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

