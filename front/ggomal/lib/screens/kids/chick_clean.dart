import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';

class ChickCleanScreen extends StatefulWidget {
  const ChickCleanScreen({super.key});

  @override
  State<ChickCleanScreen> createState() => _ChickCleanScreenState();
}

class _ChickCleanScreenState extends State<ChickCleanScreen> {
  final List<Map<String, dynamic>> _thingList = [
    {"img": 1, "isVisible": true},
    {"img": 2, "isVisible": true},
    {"img": 3, "isVisible": true},
    {"img": 4, "isVisible": true},
  ];

  void _handleCleanThing(Map<String, dynamic> thing) {
    setState(() {
      thing["isVisible"] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/chick/clean_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: NavBar(),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 4,
                    child: Stack(
                      children: [
                        Image.asset(
                          height: 600.0,
                          'assets/images/chick/thatched_house.png',
                        ),
                        Container(
                          height: 450.0,
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 80.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: _thingList
                                .map(
                                  (e) => e["isVisible"]
                                      ? GestureDetector(
                                          onTap: () => _handleCleanThing(e),
                                          child: Image.asset(
                                            width: 190.0,
                                            height: 150.0,
                                            'assets/images/chick/clean_thing_${e["img"]}.png',
                                          ),
                                        )
                                      : SizedBox(
                                          width: 190.0,
                                          height: 150.0,
                                        ),
                                )
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Image.asset(
                      'assets/images/chick/clean_character.png',
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
