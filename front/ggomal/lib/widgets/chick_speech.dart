import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/chick_dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

class ChickSpeechModal extends StatefulWidget {
  final Map<String, dynamic> speechData;

  const ChickSpeechModal(this.speechData, {super.key});

  @override
  State<ChickSpeechModal> createState() => _ChickSpeechModalState();
}

class _ChickSpeechModalState extends State<ChickSpeechModal> {
  late String currentFilePath;
  int recordCount = 0;
  final recorder = FlutterSoundRecorder();
  String filePath = '';
  List words = [];
  bool isPass = true;

  @override
  void initState() {
    super.initState();
    initRecorder();
    words = List.generate(
        "${widget.speechData['name']}${widget.speechData['ending']}".length,
        (index) => true);
  }

  Future initRecorder() async {
    var status = await Permission.speech.status;
    if (!status.isGranted) {
      print('권한 허용안됨');
      throw '마이크 권한이 허용되지 않았습니다';
    }
    await recorder.openRecorder();
  }

  void postAudio() async {
    File audioFile = File(filePath);
    if (await audioFile.exists()) {
      // String m4a = filePath.replaceAll('.aac', '.m4a');
      // await audioFile.rename(m4a);
      final response = await checkAudio(
          widget.speechData['gameNum'],
          "${widget.speechData['name']} ${widget.speechData['ending']}",
          filePath);
      print(response['overResult']);
      if (response['overResult'] || recordCount == 3) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          words = response['words'];
          isPass = response['overResult'];
        });
      }
    } else {
      print("파일이 존재하지 않습니다.");
    }
  }

  Future<void> record() async {
    Directory tempDir = await getTemporaryDirectory();
    filePath = '${tempDir.path}/chick_audio_$recordCount.wav';
    await recorder.startRecorder(toFile: filePath, codec: Codec.pcm16WAV);
    setState(() {
      currentFilePath = filePath;
    });
  }

  Future<void> stop() async {
    await recorder.stopRecorder();
    postAudio();
    setState(() {
      recordCount++;
    });
  }

  List<TextSpan> _buildTextSpans(text) {
    List<TextSpan> textSpans = [];
    for (int i = 0; i < text.length; i++) {
      Color textColor = words[i] ? Colors.black : Colors.red;
      textSpans.add(
        TextSpan(
          text: text[i],
          style: mapleText(48, FontWeight.w700, textColor),
        ),
      );
      if (i == widget.speechData['name'].length - 1) {
        textSpans.add(
          TextSpan(
            text: ' ',
            style: mapleText(48, FontWeight.w700, textColor),
          ),
        );
      }
    }
    return textSpans;
  }

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
                        child: Column(
                          children: [
                            SizedBox(
                                height: 80,
                                child: (recordCount > 0 && !isPass
                                    ? Text("다시 한번 말해볼까?",
                                        style: mapleText(
                                            30, FontWeight.w700, Colors.black))
                                    : Text(""))),
                            RichText(
                              text: TextSpan(
                                children: _buildTextSpans(
                                    "${speechData['name']}${speechData['ending']}"),
                              ),
                            ),
                            Text("$recordCount / 3",
                                style: mapleText(
                                    30, FontWeight.w700, Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (recorder.isRecording) {
                      await stop();
                    } else {
                      await record();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                    backgroundColor: Color(0xFFFFFAAC),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(recorder.isRecording ? '끝내기' : '말하기',
                      style: mapleText(20, FontWeight.w700, Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
