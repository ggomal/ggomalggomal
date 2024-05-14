import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/whale_dio.dart';
import 'package:ggomal/utils/game_bosang_dialog.dart';
import 'package:ggomal/widgets/percent_bar.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

class WhaleSea extends StatefulWidget {
  const WhaleSea({super.key});

  @override
  State<WhaleSea> createState() => _WhaleSeaState();
}

class _WhaleSeaState extends State<WhaleSea> {
  Alignment _alignment = Alignment(-0.9, -0.8);
  int directionCount = 0;
  List<List<double>> direction = [
    [0.1, 0],
    [0, 0.1],
    [-0.1, 0]
  ];

  late int _fishCount = 0;
  int seconds = 0;

  bool _isRecording = false;

  int startTime = 0;
  int endTime = 0;

  NoiseReading? _latestReading;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? noiseMeter;

  final List<Map<String, dynamic>> _fishLocation = [
    {"x": -0.6, "y": -0.6, "isVisible": true},
    {"x": -0.3, "y": -0.6, "isVisible": true},
    {"x": -0.0, "y": -0.6, "isVisible": true},
    {"x": 0.3, "y": -0.6, "isVisible": true},
    {"x": 0.6, "y": -0.6, "isVisible": true},
    {"x": -0.6, "y": 0.65, "isVisible": true},
    {"x": -0.3, "y": 0.65, "isVisible": true},
    {"x": 0.0, "y": 0.65, "isVisible": true},
    {"x": 0.3, "y": 0.65, "isVisible": true},
    {"x": 0.6, "y": 0.65, "isVisible": true},
  ];

  void onData(NoiseReading noiseReading) => setState(() {
        _latestReading = noiseReading;
        double x = _alignment.x + direction[directionCount][0];
        double y = _alignment.y + direction[directionCount][1];

        if (noiseReading.meanDecibel >= 75) {
          if (x >= -0.8 && x <= 0.8 && y >= -1 && y <= 0.8) {
            _alignment += Alignment(
                direction[directionCount][0], direction[directionCount][1]);
            int fishIndex = _fishLocation.indexWhere((location) =>
                x + 0.06 > location["x"]! &&
                x - 0.16 < location["x"]! &&
                y + 0.21 > location["y"]! &&
                y - 0.21 < location["y"]!);
            if (fishIndex != -1 && _fishLocation[fishIndex]['isVisible']) {
              _eatFish(fishIndex);
            }
          } else {
            directionCount += 1;
          }
        }
      });

  void onError(Object error) {
    print(error);
    stop();
  }

  Future<bool> checkPermission() async => await Permission.microphone.isGranted;

  Future<void> requestPermission() async =>
      await Permission.microphone.request();

  Future<void> start() async {
    startTime = DateTime.now().millisecondsSinceEpoch;
    noiseMeter ??= NoiseMeter();
    if (!(await checkPermission())) await requestPermission();
    _noiseSubscription = noiseMeter?.noise.listen(onData, onError: onError);
    setState(() => _isRecording = true);
  }

  void stop() {
    _noiseSubscription?.cancel();
    setState(() => _isRecording = false);
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
        stop();
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
          child: RotatedBox(
            quarterTurns: (directionCount + 2) % 4,
            child: Image.asset(
              'assets/images/whale/whale_diver.png',
              width: width * 0.15,
            ),
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
        _isRecording
            ? SizedBox.shrink()
            : Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: GestureDetector(
                    onTap: () => start(),
                    child: Image.asset(
                      "assets/images/whale/start_button.png",
                      width: 200,
                    ),
                  ),
                  // children: [
                  //   Container(
                  //     child: Text(_isRecording ? "Mic: ON" : "Mic: OFF",
                  //         style: TextStyle(fontSize: 25, color: Colors.blue)),
                  //     margin: EdgeInsets.only(top: 20),
                  //   ),
                  //   Container(
                  //     child: Text(
                  //       'Noise: ${_latestReading?.meanDecibel.toStringAsFixed(2)} dB',
                  //     ),
                  //     margin: EdgeInsets.only(top: 20),
                  //   ),
                  //   Container(
                  //     child: Text(
                  //       'Max: ${_latestReading?.maxDecibel.toStringAsFixed(2)} dB',
                  //     ),
                  //   ),
                  // ],
                ),
              ),
      ],
    );
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }
}
