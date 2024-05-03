import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/constants.dart';

class ChickGameModal extends StatefulWidget {
  final Map<String, dynamic> modalData;

  const ChickGameModal(this.modalData, {super.key});

  @override
  State<ChickGameModal> createState() => _ChickGameModalState();
}

class _ChickGameModalState extends State<ChickGameModal> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> modalData = widget.modalData;
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.6;
    double height = screenSize.height * 0.7;

    return Dialog(
      child: Stack(
        children: [
          Image.asset("assets/images/chick/chick_modal.png",
              width: width, height: height, fit: BoxFit.fill),
          Container(
            height: height,
            width: width,
            padding: const EdgeInsets.fromLTRB(80, 90, 80, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(modalData['title'], style: mapleText(50, FontWeight.w700, Colors.black)),
                Text(modalData['content'],
                    style: mapleText(28, FontWeight.w500, Colors.black)),
                Image.asset(
                  "assets/images/chick/modal_${modalData['game']}.png",
                  height: 200,
                ),
                ElevatedButton(
                  onPressed: () {context.go('/kids/chick/${modalData['game']}');},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFFAAC),
                    foregroundColor: Colors.white,
                  ),
                  child: Text("시작", style: mapleText(20, FontWeight.w700, Colors.black)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
