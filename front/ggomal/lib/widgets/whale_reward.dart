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
    double width = screenSize.width * 0.65;
    double height = screenSize.height * 0.7;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "assets/images/whale/whale_${modalData['result']}.png"),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                context.go("/kids");
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFD2D2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: BorderSide(color: Colors.black, width: 4.0))),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  "마을가기",
                  style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Maplestory',
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: height * 0.17,),
          ],
        ),
      ),
    );
  }
}
