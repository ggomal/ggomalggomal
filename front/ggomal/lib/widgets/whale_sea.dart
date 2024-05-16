import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/whale_dio.dart';
import 'package:ggomal/utils/game_bosang_dialog.dart';
import 'package:ggomal/widgets/percent_bar.dart';
import 'package:ggomal/widgets/whale_game.dart';
import 'package:ggomal/widgets/whale_reward.dart';
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
  final recorder = FlutterSoundRecorder();
  String filePath = '';
  List words = [true, true, true, true, true];
  List<double> xList = [-0.5, -0.25, 0.0, 0.25, 0.5];
  bool isPass = true;
  bool isLoading = false;
  int recordCount = 0;
  int _fishCount = 0;
  late int _totalFishCount = 0;
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
    requestPermission();
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
      final response = await checkAudio(filePath);
      print(response['allResult']);
      // if (response['overResult'] || recordCount == 3) {
      //   Navigator.pop(context, true);
      // } else {
      setState(() {
        words = [false, false, false, false, true];
        isPass = response['allResult'];
      });
      _timer = Timer.periodic(Duration(microseconds: 1000), (timer) {
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
          text: "${text[i]} ",
          style: mapleText(48, FontWeight.w700, textColor),
        ),
      );
    }
    return textSpans;
  }

  Alignment _alignment = Alignment(-0.9, -0.5);

  int seconds = 0;

  int startTime = 0;
  int endTime = 0;

  final List<Map<String, dynamic>> _fishLocation = [
    {"x": -0.5, "y": -0.4, "isVisible": true, "idx": 0},
    {"x": -0.25, "y": -0.4, "isVisible": true, "idx": 1},
    {"x": 0.0, "y": -0.4, "isVisible": true, "idx": 2},
    {"x": 0.25, "y": -0.4, "isVisible": true, "idx": 3},
    {"x": 0.5, "y": -0.4, "isVisible": true, "idx": 4},
  ];

  void move() {
    if (_alignment.x >= 0.9) {
      _timer.cancel();
      if (_totalFishCount >= 10) {
        Future.delayed(Duration(milliseconds: 500)).then((value) {
          showDialog(context: context,
              builder: (BuildContext context) =>
                  WhaleRewardModal(
                      {"count": 1, "totalCount": _totalFishCount, "result" : "성공"}));
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              WhaleGameModal(
                  {"fishCount": _fishCount, "totalCount": _totalFishCount}),
        ).then((value) => {
        if (recordCount >= 2){
            showDialog(context: context,
            builder: (BuildContext context) =>
                WhaleRewardModal(
                    {"count": 1, "totalCount": _totalFishCount, "result" : "실패"})),
      }
    else {
      setState(() {
        _alignment = Alignment(-0.8, -0.5);
        for (int i = 0; i < 5; i++) {
          _fishLocation[i]["x"] = xList[i];
          _fishLocation[i]["isVisible"] = true;
          _fishCount = 0;
        }
      })
    }
  });
    }
    }
    double x = _alignment.x + 0.001;
    setState(() {
    _alignment += Alignment(0.001, 0);
    });
    int fishIndex = _fishLocation.indexWhere(
    (location) => x > location["x"]! && x - 0.16 < location["x"]!);
    if (fishIndex != -1 &&
    _fishLocation[fishIndex]['isVisible'] &&
    words[fishIndex]) {
    _eatFish(fishIndex);
    }
  }

  void _eatFish(int fishIndex) {
    setState(() {
      _fishCount += 1;
      _totalFishCount += 1;
      _fishLocation[fishIndex]['isVisible'] = false;

      if (_totalFishCount == 10) {
        endTime = DateTime
            .now()
            .millisecondsSinceEpoch;
        double gameTime = (endTime - startTime) / 1000;
        whaleReword(gameTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = screenSize(context).width;
    double height = screenSize(context).height;

    return Stack(
      children: [
        ..._fishLocation
            .map(
              (e) =>
          e['isVisible'] || !words[e['idx']]
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
        AnimatedContainer(
          duration: Duration(milliseconds: 50),
          curve: Curves.easeInOut,
          alignment: _alignment,
          child: Image.asset(
            'assets/images/whale/whale_diver.png',
            width: width * 0.12,
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width / 2 - 200,
            height: 80,
            padding: const EdgeInsets.all(20),
            child: PercentBar({
              "count": _totalFishCount,
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: height * 0.1,
                          child: Text("'아에이오우' 를 말하고 물고기를 먹어봐 !",
                              style: mapleText(
                                  40, FontWeight.w700, Colors.black))),
                      SizedBox(
                        height: height * 0.1,
                        child: RichText(
                          text: TextSpan(
                            children: _buildTextSpans("아에이오우"),
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.1,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color:
                          isLoading ? Color(0xFFC3C3C3) : Color(0xFFFFC107),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          children: [
                            IconButton(
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
                          ],
                        ),
                      ),
                      Text(
                        recorder.isRecording
                            ? "종료 버튼을 눌러주세요."
                            : isLoading
                            ? "AI 발음 정밀 분석  중입니다."
                            : "버튼을 눌러 말해보세요.",
                        style: mapleText(
                            24, FontWeight.w500, Colors.grey.shade700),
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
