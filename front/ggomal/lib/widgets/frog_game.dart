import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ggomal/constants.dart';
import 'package:gif/gif.dart';
import '../services/frog_dio.dart';
import '../utils/game_bosang_dialog.dart';
import '../utils/game_dialog2.dart';
import '../utils/navbar.dart';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_vision/flutter_vision.dart';
import 'percent_bar.dart';

enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }

late List<CameraDescription> cameras;

class FrogTown extends StatefulWidget {
  const FrogTown({Key? key}) : super(key: key);

  @override
  State<FrogTown> createState() => _FrogTownState();
}

class _FrogTownState extends State<FrogTown> {
  late FlutterVision vision;
  Options option = Options.none;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    super.initState();
    vision = FlutterVision();
  }

  @override
  void dispose() async {
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
    super.dispose(); // 이 부분을 수정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      body: Stack(
        children: [
          Positioned(
              // bottom: 0,
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: YoloVideo(vision: vision),
          )),
          //FrogGame(key: frogGameStateKey),
        ],
      ),
    );
  }
}

class YoloVideo extends StatefulWidget {
  final FlutterVision vision;

  const YoloVideo({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> with TickerProviderStateMixin {
  late final GifController controller1, controller2, controller3;
  final AudioPlayer player = AudioPlayer();
  final AudioPlayer player_frog = AudioPlayer();
  final AudioPlayer player_gif = AudioPlayer();
  // 개구리 게임
  late int _fishCount = 0;

  Random random = Random();
  final List<Map<String, dynamic>> _fishLocation = [
    // {"x": -0.4, "y": -0.2, "isVisible": true, "width": 95},
    // {"x": -0.3, "y": 0.2, "isVisible": true, "width": 100},
    // {"x": 0.1, "y": -0.5, "isVisible": true, "width": 105},
    // {"x": 0.4, "y": 0.2, "isVisible": true, "width": 95},
    // {"x": -0.6, "y": 0.3, "isVisible": true, "width": 105},
    {"x": -0.7, "y": -0.7, "isVisible": true, "width": 80},
    {"x": -0.4, "y": -0.4, "isVisible": true, "width": 120},
    {"x": -0.1, "y": -0.6, "isVisible": true, "width": 95},
    {"x": 0.4, "y": -0.4, "isVisible": true, "width": 110},
    {"x": 0.7, "y": -0.5, "isVisible": true, "width": 102},
  ];

  List<int> _availableIndexes = [
    0,
    1,
    2,
    3,
    4,
    // 5,
    // 6,
    // 7,
    // 8,
    // 9
  ]; // 사용 가능한 인덱스 리스트

  bool _isStart = false;

  void _eatItem(int index) {
    setState(() {
      _fishCount += 1;
      _fishLocation[index]['isVisible'] = false;
      _availableIndexes.remove(index); // 인덱스 사용 후 제거

      player_frog.setVolume(1.0);
      player_frog.play(AssetSource('audio/frog/frog_eating.mp3'));
      // player_gif.play(AssetSource('audio/frog/frog_taste.mp3'));

      if (_fishCount == 5) {
        frogReword();
        Future.delayed(Duration(milliseconds: 500)).then((value) {
          stopDetection();

          showDialog(
            context: context,
            builder: (BuildContext context) => GameContinueDialog2(
              continuePage: '/kids/frog',
              count: 2,
              onRestart: () {
                _restartGame();
              },
            ),
          );
        });
      }
    });
  }

  void _restartGame() {
    setState(() {
      _fishCount = 0;
      _fishLocation
          .forEach((fish) => fish['isVisible'] = true); // 모든 물고기를 다시 보이게 설정
      _availableIndexes =
          List.generate(_fishLocation.length, (index) => index); // 인덱스 리스트 재설정
      _isStart = true;
      startDetection(); // 감지 재시작
    });
  }

  //
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    controller1 = GifController(vsync: this);
    controller2 = GifController(vsync: this);
    controller3 = GifController(vsync: this);
    init();
    // player.setVolume(0.1);
    // player.setReleaseMode(ReleaseMode.loop);
    // player.play(AssetSource('audio/frog/frog_game.mp3'));
  }

  init() async {
    cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    controller = CameraController(frontCamera, ResolutionPreset.ultraHigh);
    controller.initialize().then((value) {
      loadYoloModel().then((value) async {
        setState(() {
          isLoaded = true;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    // player.stop();
    super.dispose(); // 이 부분을 수정
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(
            controller,
          ),
        ),
        //...displayBoxesAroundRecognizedObjects(size),
        Positioned(
          top: 220,
          right: 780,
          // left: 0,
          // bottom: 75,
          // width: 250,
          child: Container(
            // height: 60,
            // width: 80,
            child: isDetecting
                ? GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      // decoration: BoxDecoration(
                      //     color: Color(0xFFFE5757),
                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(color: Colors.black, width: 2)
                      // ),
                      child: Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                  left: 200,
                                  top: 50,
                                  child: Image.asset(
                                    "assets/images/frog/frog_tongue_text.png",
                                    width: 200,
                                  ),
                                ),
                                Positioned(
                                    child: Gif(
                                  width: 600,
                                  controller: controller2,
                                  duration: const Duration(seconds: 20),
                                  autostart: Autostart.once,
                                  placeholder: (context) => const Center(
                                      child: CircularProgressIndicator()),
                                  image: const AssetImage(
                                      'assets/images/frog/frog_tongue_new.gif'),
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      await startDetection();
                    },
                    child: Container(
                      // decoration: BoxDecoration(
                      //     color: Color(0xFFFE5757),
                      //     borderRadius: BorderRadius.circular(10),
                      //     border: Border.all(color: Colors.black, width: 2)
                      // ),
                      child: Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Positioned(
                                    left: 200,
                                    top: 40,
                                    child: Image.asset(
                                  "assets/images/frog/frog_eat_text.png",
                                  width: 200,
                                )),
                                Positioned(
                                    child: Gif(
                                  width: 600,
                                  controller: controller2,
                                  duration: const Duration(seconds: 20),
                                  autostart: Autostart.once,
                                  placeholder: (context) => const Center(
                                      child: CircularProgressIndicator()),
                                  image: const AssetImage(
                                      'assets/images/frog/frog_eat.gif'),
                                ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        ..._fishLocation.asMap().entries.map((entry) {
          final int index = entry.key;
          final Map<String, dynamic> fish = entry.value;

          return fish['isVisible']
              ? Positioned(
                  left: (fish['x'] as double) *
                          MediaQuery.of(context).size.width /
                          2 +
                      MediaQuery.of(context).size.width / 2,
                  top: (fish['y'] as double) *
                          MediaQuery.of(context).size.height /
                          2 +
                      MediaQuery.of(context).size.height / 2,
                  child: GestureDetector(
                    onTap: () => _eatItem(index),
                    child: Image.asset("assets/images/frog/strawberry_ss.png",
                        width: fish['width'] / 1.0),
                  ),
                )
              : Container();
        }).toList(),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 200,
            height: 80,
            padding: const EdgeInsets.all(20),
            child: PercentBar({
              "endCount" : 5,
              "count": _fishCount,
              "barColor": Color(0xFFFF835C),
              "imgUrl": "assets/images/frog/strawberry_ss.png"
            }),
          ),
        ),
        _isStart
            ? SizedBox.shrink()
            : Container(
                height: size.height * 0.1,
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      player.play(AssetSource('audio/touch.mp3'));
                      await startDetection();
                      setState(() {
                        _isStart = true;
                      });
                    },
                    child: Stack(
                      children: [
                        Positioned(
                            child: Image.asset(
                          "assets/images/frog/frog_info.png", width: size.width * 0.7,
                        )),
                        Positioned(
                            top: size.height * 0.5,
                            left: size.width * 0.25,
                            child: Image.asset(
                              "assets/images/frog/start_button.png",
                              width: size.width * 0.2,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/tongue_tt.tflite',
        modelVersion: "yolov5",
        numThreads: 2,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    // if(isDetecting) return;

    final result = await widget.vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );

    if (result.isNotEmpty) {
      setState(() {
        // yoloResults = result;
        print("============================= 혀임 !!!!!!!!!!");
        //print(result);
        isDetecting = false;
      });

      int randomIndex =
          _availableIndexes[random.nextInt(_availableIndexes.length)];
      _eatItem(randomIndex);

      Future.delayed(Duration(milliseconds: 2500), () {
        setState(() {
          isDetecting = true;
        });
      });
    }
  }

  Future<void> startDetection() async {
    print("#######################################");
    player_gif.play(AssetSource('audio/frog/frog_tongue.mp3'));
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      _isStart = false;
      yoloResults.clear();
    });
  }
}
