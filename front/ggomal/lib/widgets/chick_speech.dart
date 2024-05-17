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
  bool isLoading = false;
  bool isSpeak = true;

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
      final response = await checkAudio(
          widget.speechData['gameNum'],
          "${widget.speechData['name']} ${widget.speechData['ending']}",
          filePath);
      if (response['overResult'] || recordCount >= 2) {
        print("통과 음성");
        Navigator.pop(context, true);
      } else {
        print("다시 한번 얘기해보자 음성");
        setState(() {
          words = response['words'];
          isPass = response['overResult'];
          isLoading = false;
          isSpeak = false;
          recordCount++;
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
      isSpeak = true;
      currentFilePath = filePath;
    });
  }

  Future<void> stop() async {
    await recorder.stopRecorder();
    postAudio();
    setState(() {
      isLoading = true;
    });
  }

  List<TextSpan> _buildTextSpans(text) {
    List<TextSpan> textSpans = [];
    if (isSpeak) {
      for (int i = 0; i < text.length; i++) {
        textSpans.add(
          TextSpan(
            text: text[i],
            style: mapleText(48, FontWeight.w700, Colors.grey.shade300),
          ),
        );
        if (i == widget.speechData['name'].length - 1) {
          textSpans.add(
            TextSpan(
              text: ' ',
              style: mapleText(48, FontWeight.w700, Colors.grey.shade300),
            ),
          );
        }
      }
    } else {
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
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Image.asset("assets/images/modal_frame.png",
              width: width, height: height, fit: BoxFit.fill),
          Container(
            height: height,
            width: width,
            padding: const EdgeInsets.symmetric(
              vertical: 60,
              horizontal: 100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Row(children: [
                    Flexible(
                        flex: 1,
                        child: Container(
                          height: height * 0.4,
                            padding: const EdgeInsets.only(left : 20),
                            child: Image.asset(
                                "assets/images/chick/${speechData['game']}_thing_${speechData['img']}.png"),
                        )),
                    Flexible(
                      flex: 2,
                      child: Center(
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: _buildTextSpans(
                                    "${speechData['name']}${speechData['ending']}"),
                              ),
                            ),
                            Text("$recordCount / 3",
                                style: mapleText(
                                    40, FontWeight.w700, Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  height: 80,
                  decoration: BoxDecoration(
                    color: isLoading ? Color(0xFFC3C3C3) : Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () async {
                        if (recorder.isRecording) {
                          await stop();
                        } else {
                          isLoading ? null : await record();
                        }
                      },
                      icon: Icon(
                        recorder.isRecording
                            ? Icons.stop_rounded
                            : isLoading
                                ? Icons.more_horiz
                                : Icons.mic,
                        color: Colors.white,
                        size: 60,
                      )),
                ),
                Text(
                  recorder.isRecording
                      ? "종료 버튼을 눌러주세요."
                      : isLoading
                          ? "AI 발음 정밀 분석  중입니다."
                          : "버튼을 눌러 말해보세요.",
                  style: mapleText(24, FontWeight.w500, Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
