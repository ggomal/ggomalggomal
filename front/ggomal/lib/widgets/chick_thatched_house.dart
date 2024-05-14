import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/chick_dio.dart';
import 'package:ggomal/utils/game_bosang_dialog.dart';
import 'package:ggomal/widgets/chick_speech.dart';

class ChickThatchedHouse extends StatefulWidget {
  const ChickThatchedHouse({super.key});

  @override
  State<ChickThatchedHouse> createState() => _ChickThatchedHouseState();
}

class _ChickThatchedHouseState extends State<ChickThatchedHouse> {
  int count = 0;
  List<Map<String, dynamic>> thingList = [
    {"name": "이불", "img": 1, "isVisible": true},
    {"name": "돌", "img": 2, "isVisible": true},
    {"name": "물", "img": 3, "isVisible": true},
    {"name": "안경", "img": 4, "isVisible": true},
  ];

  void handleCleanThing(Map<String, dynamic> thing) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ChickSpeechModal({
        "gameNum": 2,
        "game": "clean",
        "name": thing['name'],
        "img": thing['img'],
        "ending": "정리해주세요"
      }),
    ).then((value) => {
          if (value)
            {
              setState(() {
                thing["isVisible"] = false;
                count += 1;
                if (count == 4) {
                  chickReword(1, 2);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        GameContinueDialog(continuePage: '/chick', count: 2),
                  );
                }
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = screenSize(context).width;
    double height = screenSize(context).height;

    return Flexible(
      flex: 4,
      child: Stack(
        children: [
          Image.asset(
            height: height * 0.8,
            'assets/images/chick/thatched_house.png',
          ),
          Container(
            height: height * 0.6,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: thingList
                  .map(
                    (e) => e["isVisible"]
                        ? GestureDetector(
                            onTap: () => handleCleanThing(e),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(11, 0, 11, 0),
                                  child: Image.asset(
                                    width: width * 0.14,
                                    height: height * 0.18,
                                    'assets/images/chick/clean_thing_${e["img"]}.png',
                                  ),
                                ),
                                SizedBox(
                                    height: 50,
                                    child: Text(e["name"],
                                        style: mapleText(40, FontWeight.normal,
                                            Colors.black))),
                              ],
                            ),
                          )
                        : SizedBox(
                            width: width * 0.14,
                            height: height * 0.18,
                          ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
