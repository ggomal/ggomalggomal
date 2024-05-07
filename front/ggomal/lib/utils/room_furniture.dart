import 'package:flutter/material.dart';

class FurnitureDialog extends StatefulWidget {
  const FurnitureDialog({super.key});

  @override
  State<FurnitureDialog> createState() => _FurnitureDialogState();
}

class _FurnitureDialogState extends State<FurnitureDialog> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.8;
    double height = screenSize.height * 0.8;
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/home/room_modal.png"),
            fit: BoxFit.fill,
          )),
        ));
  }
}

