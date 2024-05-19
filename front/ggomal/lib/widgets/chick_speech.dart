import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/chick_dio.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer player = AudioPlayer();

  String filePath = '';
  List words = [];
  bool isPass = true;
  bool isLoading = false;
  bool isSpeak = true;
  bool isEnd = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
    words = List.generate(
        "${widget.speechData['name']}${widget.speechData['ending']}".length,
        (index) => true);
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    player.stop();
    super.dispose();
  }

  Future<bool> checkPermission() async => await Permission.microphone.isGranted;

  Future<void> requestPermission() async =>
      await Permission.microphone.request();

  Future initRecorder() async {
    await requestPermission();
    var status = await Permission.speech.status;
    if (!status.isGranted) {
      print('권한 허용안됨');
      throw '마이크 권한이 허용되지 않았습니다';
    }
    setState((){});
    await recorder.openRecorder();
  }

  void postAudio() async {
    File audioFile = File(filePath);
    if (await audioFile.exists()) {
      final response = await checkAudio(
          widget.speechData['gameNum'],
          "${widget.speechData['name']} ${widget.speechData['ending']}",
          filePath);

      if (mounted) {
        setState(() {
          words = response['words'];
          isPass = response['overResult'];
          isLoading = false;
          isSpeak = false;
          recordCount++;
        });
      }
      if (response['overResult'] || recordCount >= 3) {
        setState(() {
          isEnd = true;
        });
        if (response['overResult']) {
          player.play(AssetSource('audio/chick/pass.mp3'));
        } else {
          player.play(AssetSource('audio/chick/good.mp3'));
        }
        Future.delayed(Duration(milliseconds: 1000)).then((value) {
          if (mounted) {
            player.play(AssetSource('audio/chick/speech_pass.mp3'));
            Future.delayed(Duration(milliseconds: 300)).then((value) {
              Navigator.pop(context, true);
            });
          }
        });
      } else {
        player.play(AssetSource('audio/chick/fail.mp3'));
        setState(() {
          words = response['words'];
          isRecording = false;
        });
      }
    } else {
      print("파일이 존재하지 않습니다.");
    }
  }

  Future<void> record() async {
    if (!isRecording) {
      isRecording = true;
      player.play(AssetSource('audio/record.mp3'));
      Directory tempDir = await getTemporaryDirectory();
      filePath = '${tempDir.path}/chick_audio_$recordCount.wav';
      await recorder.startRecorder(toFile: filePath, codec: Codec.pcm16WAV);
      if (mounted) {
        setState(() {
          isSpeak = true;
          currentFilePath = filePath;
        });
      }
    } else {
      return;
    }
  }

  Future<void> stop() async {
    player.play(AssetSource('audio/record.mp3'));
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    Future.delayed(Duration(milliseconds: 500)).then((value) async {
      await recorder.stopRecorder();
      postAudio();
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
        Color textColor = isPass? Colors.green : words[i] ? Colors.black : Colors.red;
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
                          padding: const EdgeInsets.only(left: 20),
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
                    color: isLoading || isEnd
                        ? Color(0xFFC3C3C3)
                        : Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () async {
                        if (recorder.isRecording) {
                          await stop();
                        } else {
                          isLoading || isEnd ? null : await record();
                        }
                      },
                      icon: isLoading
                          ? LoadingAnimationWidget.fourRotatingDots(
                              color: Colors.white,
                              size: 60,
                            )
                          : Icon(
                              recorder.isRecording
                                  ? Icons.stop_rounded
                                  : Icons.mic,
                              color: Colors.white,
                              size: 60,
                            )),
                ),
                Text(
                  isLoading
                      ? "AI 발음 정밀 분석  중입니다."
                      : recorder.isRecording
                          ? "종료 버튼을 눌러주세요."
                          : "버튼을 눌러 말해보세요.",
                  style: mapleText(24, FontWeight.w500, Colors.grey),
                )
              ],
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(Icons.cancel),
              iconSize: 50,
              onPressed: () {
                isLoading || recorder.isRecording
                    ? null
                    : Navigator.pop(context, false);
              },
            ),
          )
        ],
      ),
    );
  }
}
