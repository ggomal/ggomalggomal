import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/whale_dio.dart';
import 'package:ggomal/utils/game_bosang_dialog.dart';
import 'package:ggomal/widgets/percent_bar.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';

class WhaleSea extends StatefulWidget {
  const WhaleSea({super.key});

  @override
  State<WhaleSea> createState() => _WhaleSeaState();
}

class _WhaleSeaState extends State<WhaleSea> {
  late String currentFilePath;
  int recordCount = 0;
  final recorder = FlutterSoundRecorder();
  String filePath = '';
  List words = [true, true, true, true, true];
  bool isPass = true;
  // bool isPass = true;
  bool isLoading = false;
  late Timer _timer;


  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  Future<bool> checkPermission() async => await Permission.microphone.isGranted;

  Future<void> requestPermission() async =>
      await Permission.microphone.request();

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
      // final response = await checkAudio(
      //     widget.speechData['gameNum'],
      //     "${widget.speechData['name']} ${widget.speechData['ending']}",
      //     filePath);
      final response = [true, false, true, true, true];
      // print(response['overResult']);
      // if (response['overResult'] || recordCount == 3) {
      //   Navigator.pop(context, true);
      // } else {
      setState(() {
        // words = response['words'];
        // isPass = response['overResult'];
        words = response;
        isPass = false;
      });
      _timer = Timer.periodic(Duration(microseconds: 200), (timer) {
        move();

      });

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
    }
    return textSpans;
  }

  Alignment _alignment = Alignment(-0.9, -0.5);

  late int _fishCount = 0;
  int seconds = 0;

  int startTime = 0;
  int endTime = 0;

  final List<Map<String, dynamic>> _fishLocation = [
    {"x": -0.4, "y": -0.4, "isVisible": true},
    {"x": -0.1, "y": -0.4, "isVisible": true},
    {"x": 0.2, "y": -0.4, "isVisible": true},
    {"x": 0.5, "y": -0.4, "isVisible": true},
    {"x": 0.8, "y": -0.4, "isVisible": true},
  ];

  void move() {
    print("움직여라");
    if (_alignment.x >= 0.9) {
      _timer.cancel();
    }
    double x = _alignment.x + 0.01;
    setState(() {
      _alignment += Alignment(0.01, 0);

    });
    int fishIndex = _fishLocation.indexWhere((location) =>
    x + 0.06 > location["x"]! && x - 0.16 < location["x"]!);
    if (fishIndex != -1 && _fishLocation[fishIndex]['isVisible']) {
      _eatFish(fishIndex);
    }
  }



  void _eatFish(int fishIndex) {
    setState(() {
      _fishCount += 1;
      _fishLocation[fishIndex]['isVisible'] = false;

      if (_fishCount == 10) {
        endTime = DateTime.now().millisecondsSinceEpoch;
        double gameTime = (endTime - startTime) / 1000;
        whaleReword(gameTime);
        Future.delayed(Duration(milliseconds: 500)).then((value) {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                GameContinueDialog(continuePage: '/whale', count: 1),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = screenSize(context).width;
    double height = screenSize(context).height;

    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: _alignment,
          child: Image.asset(
            'assets/images/whale/whale_diver.png',
            width: width * 0.15,
          ),
        ),
        ..._fishLocation
            .map(
              (e) => e['isVisible']
              ? Align(
            alignment: Alignment(e['x'] as double, e['y'] as double),
            child: Image.asset(
              "assets/images/whale/fish_pink.png",
              width: width * 0.05,
            ),
          )
              : Text(""),
        )
            .toList(),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 200,
            height: 80,
            padding: const EdgeInsets.all(20),
            child: PercentBar({
              "count": _fishCount,
              "barColor": Color(0xFFFF835C),
              "imgUrl": "assets/images/whale/fish_pink.png"
            }),
          ),
        ),
        Positioned(
            bottom: 30,
            width: width,
            height: height * 0.4,
            child: Center(
              child: Container(
                width: width * 0.8,
                color: Colors.white.withOpacity(0.5),
                child: Column(children: [
                  Text("아에이오우를 말하고 물고기를 먹어봐 !"),
                  Text("아에이오우"),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
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
                ]),
              ),
            ))
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
