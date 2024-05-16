import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/get_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class WhaleRewardModal extends StatelessWidget {
  final Map<String, dynamic> modalData;

  const WhaleRewardModal(this.modalData, {super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<CoinController>().coin();

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.6;
    double height = screenSize.height * 0.7;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/game_bosang_modal.png"),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Flexible(flex: 8, child: Container()),
                  Flexible(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          child: Text(
                            "${modalData["count"]}개",
                            style: mapleText(40, FontWeight.bold, Colors.black),
                          ),
                        ),
                      )),
                  Flexible(flex: 4, child: Container()),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.go("/kids");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFD2D2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side:
                                  BorderSide(color: Colors.black, width: 4.0))),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Text(
                          "마을가기",
                          style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'Maplestory',
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(flex: 1, child: Container())
          ],
        ),
      ),
    );
  }
}
