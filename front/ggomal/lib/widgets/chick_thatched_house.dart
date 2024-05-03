import 'package:flutter/material.dart';
import 'package:ggomal/widgets/chick_speech.dart';

class ChickThatchedHouse extends StatefulWidget {
  const ChickThatchedHouse({super.key});

  @override
  State<ChickThatchedHouse> createState() => _ChickThatchedHouseState();
}

class _ChickThatchedHouseState extends State<ChickThatchedHouse> {
  List<Map<String, dynamic>> thingList = [
    {"name": "이불", "img": 1, "isVisible": true},
    {"name": "돌", "img": 2, "isVisible": true},
    {"name": "물", "img": 3, "isVisible": true},
    {"name": "안경", "img": 4, "isVisible": true},
  ];

  void handleCleanThing(Map<String, dynamic> thing) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          ChickSpeechModal({"game": "clean", "name": thing['name'], "img": thing['img'], "ending": "정리해"}),
    ).then((value) => {
          if (value)
            {
              setState(() {
                thing["isVisible"] = false;
              })
            }
        });
    print("$thingList");
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
              children: thingList
                  .map(
                    (e) => e["isVisible"]
                        ? GestureDetector(
                            onTap: () => handleCleanThing(e),
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
    );
  }
}
