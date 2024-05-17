import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/constants.dart';

class WhaleGameModal extends StatefulWidget {
  final Map<String, dynamic> modalData;

  const WhaleGameModal(this.modalData, {super.key});

  @override
  State<WhaleGameModal> createState() => _WhaleGameModalState();
}

class _WhaleGameModalState extends State<WhaleGameModal> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> modalData = widget.modalData;
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.6;
    double height = screenSize.height * 0.7;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Image.asset("assets/images/modal_frame.png",
              width: width, height: height, fit: BoxFit.fill),
          Container(
            height: height,
            width: width,
            padding: const EdgeInsets.fromLTRB(100, 150, 100, 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${modalData['fishCount']} 마리를 먹었어요!",style: mapleText(60, FontWeight.w700, Colors.black))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/whale/fish_pink.png", height: 60,),
                    Text("${modalData['totalCount']} / 10",style: mapleText(60, FontWeight.w700, Colors.black))
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFFAAC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 40,
                    ),
                  ),
                  child: Text("계속하기",
                      style: mapleText(40, FontWeight.w700, Colors.black)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
