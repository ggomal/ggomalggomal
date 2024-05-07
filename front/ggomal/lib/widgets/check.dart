import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';

class CheckModal extends StatelessWidget {
  final String modalData;
  const CheckModal(this.modalData, {super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.5;
    double height = screenSize.height * 0.6;

    return Dialog(
        child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            blurRadius: 5.0,
            offset: Offset(3, 3),
          ),
        ],
      ),
      width: width,
      height: height,
      padding: const EdgeInsets.all(40),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
        SizedBox(
          height: 100,
          child: Text("!", style: nanumText(30, FontWeight.w900, Colors.black)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(modalData,
                style: nanumText(24, FontWeight.w700, Colors.black))
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFAA8D),
            foregroundColor: Colors.white,
          ),
          child: Text("확인"),
        ),
      ]),
    ));
  }
}
