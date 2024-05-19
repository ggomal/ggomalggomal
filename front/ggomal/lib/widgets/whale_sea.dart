import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/whale_dio.dart';
import 'package:ggomal/widgets/percent_bar.dart';
import 'package:ggomal/widgets/whale_game.dart';
import 'package:ggomal/widgets/whale_reward.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:audioplayers/audioplayers.dart';

class WhaleSea extends StatefulWidget {
  const WhaleSea({super.key});

  @override
  State<WhaleSea> createState() => _WhaleSeaState();
}

class _WhaleSeaState extends State<WhaleSea> {
  late String currentFilePath;
  final recorder = FlutterSoundRecorder();
  final AudioPlayer player = AudioPlayer();
  String filePath = '';
  List words = [true, true, true, true, true];
  List<double> xList = [-0.6, -0.25, 0.1, 0.45, 0.8];
  bool isPass = true;
  bool isLoading = false;
  bool isMoving = false;
  bool isSpeak = true;
  List<bool> isCount = [true, true, true];
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
      setState(() {
        isMoving = true;
        words = response['wordResult'];
        // words = [true, true, true, true, true];
        isPass = response['allResult'];
        isLoading = false;
        isSpeak = false;
      });
      _timer = Timer.periodic(Duration(microseconds: 1000), (timer) {
        move();
      });
    } else {
      print("파일이 존재하지 않습니다.");
    }
  }

  Future<void> record() async {
    player.play(AssetSource('audio/record.mp3'));
    Directory tempDir = await getTemporaryDirectory();
    filePath = '${tempDir.path}/chick_audio_$recordCount.wav';
    await recorder.startRecorder(toFile: filePath, codec: Codec.pcm16WAV);
    setState(() {
      isSpeak = true;
      currentFilePath = filePath;
    });
  }

  Future<void> stop() async {
    player.play(AssetSource('audio/record.mp3'));
    setState(() {
      isLoading = true;
      isCount[recordCount] = false;
      recordCount++;
    });
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
            text: "${text[i]} ",
            style: mapleText(48, FontWeight.w700, Colors.grey.shade500),
          ),
        );
      }
    } else {
      for (int i = 0; i < text.length; i++) {
        Color textColor = words[i] ? Colors.black : Colors.red;
        textSpans.add(
          TextSpan(
            text: "${text[i]} ",
            style: mapleText(48, FontWeight.w700, textColor),
          ),
        );
      }
    }
    return textSpans;
  }

  Alignment _alignment = Alignment(-0.9, -0.5);

  int seconds = 0;

  int startTime = 0;
  int endTime = 0;

  final List<Map<String, dynamic>> _fishLocation = [
    {"idx": 0, "x": -0.6, "y": -0.45, "isVisible": true, "word": "a"},
    {"idx": 1, "x": -0.25, "y": -0.45, "isVisible": true, "word": "e"},
    {"idx": 2, "x": 0.1, "y": -0.45, "isVisible": true, "word": "i"},
    {"idx": 3, "x": 0.45, "y": -0.45, "isVisible": true, "word": "o"},
    {"idx": 4, "x": 0.8, "y": -0.45, "isVisible": true, "word": "u"},
  ];

  void move() {
    if (_alignment.x >= 0.9) {
      _timer.cancel();
      if (_totalFishCount >= 6) {
        endTime = DateTime.now().millisecondsSinceEpoch;
        whaleReward(2);
        Future.delayed(Duration(milliseconds: 500)).then((value) {
          showDialog(
              context: context,
              builder: (BuildContext context) => WhaleRewardModal({
                    "count": 1,
                    "totalCount": _totalFishCount,
                    "result": "pass"
                  }));
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => WhaleGameModal(
              {"fishCount": _fishCount, "totalCount": _totalFishCount}),
        ).then((value) => {
              if (recordCount >= 3)
                {
                  endTime = DateTime.now().millisecondsSinceEpoch,
                  whaleReward(1),
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => WhaleRewardModal({
                            "count": 1,
                            "totalCount": _totalFishCount,
                            "result": "fail"
                          })),
                }
              else
                {
                  setState(() {
                    _alignment = Alignment(-0.9, -0.5);
                    for (int i = 0; i < 5; i++) {
                      _fishLocation[i]["x"] = xList[i];
                      _fishLocation[i]["isVisible"] = true;
                      _fishCount = 0;
                      isMoving = false;
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
      player.play(
          AssetSource('audio/whale/${_fishLocation[fishIndex]['word']}.mp3'));
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
              (e) => e['isVisible'] || !words[e['idx']]
                  ? Align(
                      alignment: Alignment(e['x'] as double, e['y'] as double),
                      child: Image.asset(
                        "assets/images/whale/fish_${e['word']}.png",
                        width: width * 0.1,
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
            width: MediaQuery.of(context).size.width / 2 - 200,
            height: 80,
            padding: const EdgeInsets.all(20),
            child: PercentBar({
              "endCount" : 6,
              "count": _totalFishCount,
              "barColor": Color(0xFFFF835C),
              "imgUrl": "assets/images/whale/green_fish.png"
            }),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: isCount
                  .map((e) => Image.asset('assets/images/whale/starfish.png',
                      width: width * 0.05,
                      color: e ? null : Colors.grey.withOpacity(0.5)))
                  .toList(),
            ),
          ),
        ),
        Positioned(
            bottom: 30,
            width: width,
            height: height * 0.4,
            child: Center(
              child: Container(
                width: width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: height * 0.1,
                          child: Text("'아에이오우' 를 말하고 물고기를 먹어봐 !",
                              style: mapleText(
                                  36, FontWeight.w700, Colors.black))),
                      SizedBox(
                        height: height * 0.1,
                        child: RichText(
                          text: TextSpan(
                            children: _buildTextSpans("아에이오우"),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 80,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: (isLoading || isMoving)
                              ? Color(0xFFC3C3C3)
                              : Color(0xFFFFC107),
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          children: [
                            isLoading
                                ? LoadingAnimationWidget.fourRotatingDots(
                                    color: Colors.white,
                                    size: 60,
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      recorder.isRecording
                                          ? await stop()
                                          : isMoving
                                              ? null
                                              : await record();
                                    },
                                    icon: Icon(
                                      recorder.isRecording
                                          ? Icons.stop_rounded
                                          : Icons.mic,
                                      color: Colors.white,
                                      size: 40,
                                    )),
                          ],
                        ),
                      ),
                      Text(
                        isMoving
                            ? "물고기를 먹는 중이에요."
                            : isLoading
                                ? "AI 발음 정밀 분석  중입니다."
                                : recorder.isRecording
                                    ? "종료 버튼을 눌러주세요."
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
