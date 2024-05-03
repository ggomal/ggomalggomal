import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';


class ChickSpeechModal extends StatefulWidget {
  final Map<String, dynamic> speechData;

  const ChickSpeechModal(this.speechData, {super.key});

  @override
  State<ChickSpeechModal> createState() => _ChickSpeechModalState();
}

class _ChickSpeechModalState extends State<ChickSpeechModal> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> speechData = widget.speechData;
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
            padding: const EdgeInsets.all(80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  child: Row(children: [
                    Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 250,
                          child: Center(
                            child: Image.asset(
                                "assets/images/chick/${speechData['game']}_thing_${speechData['img']}.png"),
                          ),
                        )),
                    Flexible(
                      flex: 2,
                      child: Center(
                          child: Text("${speechData['name']} ${speechData['ending']}", style: mapleText(60, FontWeight.w700, Colors.black))
                      ),
                    ),
                  ]),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('...'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
