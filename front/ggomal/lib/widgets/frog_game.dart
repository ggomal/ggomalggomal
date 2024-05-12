import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
    super.dispose();
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      body:
      Stack(
        children: [
          Positioned(
            // bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: YoloVideo(
                    vision: vision
                ),
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

class _YoloVideoState extends State<YoloVideo> {
  // 개구리 게임
  late int _fishCount = 0;

  Random random = Random();
  final List<Map<String, dynamic>> _fishLocation = [
    {"x": -0.7, "y": -0.7, "isVisible": true, "width" : 50},
    {"x": -0.4, "y": -0.2, "isVisible": true, "width" : 55},
    {"x": -0.3, "y": 0.2, "isVisible": true, "width" : 60},
    {"x": -0.2, "y": -0.4, "isVisible": true, "width" : 70},
    {"x": -0.1, "y": -0.6, "isVisible": true, "width" : 65},
    {"x": 0.1, "y": -0.5, "isVisible": true, "width" : 69},
    {"x": 0.4, "y": 0.2, "isVisible": true, "width" : 65},
    {"x": 0.5, "y": -0.4, "isVisible": true, "width" : 55},
    {"x": -0.6, "y": 0.3, "isVisible": true, "width" : 53},
    {"x": 0.7, "y": -0.5, "isVisible": true, "width" : 72},
  ];

  List<int> _availableIndexes = [0,1,2,3,4,5,6,7,8,9]; // 사용 가능한 인덱스 리스트

  bool _isStart = false;

  void _eatItem(int index) {
    setState(() {
      _fishCount += 1;
      _fishLocation[index]['isVisible'] = false;
      _availableIndexes.remove(index); // 인덱스 사용 후 제거

      if(_fishCount == 10){
        frogReword();
        Future.delayed(Duration(milliseconds: 500)).then((value) {
          stopDetection();

          showDialog(
            context: context,
            builder: (BuildContext context) =>
                GameContinueDialog2(continuePage: '/kids/frog', count: 2, onRestart: (){_restartGame();},),
          );
        });


      }
    });
  }

  void _restartGame() {
    setState(() {
      _fishCount = 0;
      _fishLocation.forEach((fish) => fish['isVisible'] = true);  // 모든 물고기를 다시 보이게 설정
      _availableIndexes = List.generate(_fishLocation.length, (index) => index);  // 인덱스 리스트 재설정
      _isStart = true;
      startDetection();  // 감지 재시작
    });
  }
  //
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;


  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    controller = CameraController(
        frontCamera,
        ResolutionPreset.ultraHigh
    );
    controller.initialize().then((value) {
      loadYoloModel().then((value) async {
        setState(() {
          isLoaded = true;
          // isDetecting = false; <------------여기
          yoloResults = [];
        });
        // await startDetection();
      });
    });

  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
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
          bottom: 75,
          width: 250,
          child: Container(
            height: 60,
            width: 80,
            child: isDetecting
                ? GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFE5757),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2)
                ),
                child: Center(
                  child: Text("혀를 내밀어봐요 !", style: TextStyle(
                      fontFamily: 'Maplestory',
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),),
                ),
              ),
            )
                : GestureDetector(
              onTap: () async {
                await startDetection();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFE5757),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2)
                ),
                child: Center(
                  child: Text("냠냠", style: TextStyle(
                      fontFamily: 'Maplestory',
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),),
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
            left: (fish['x'] as double) * MediaQuery.of(context).size.width / 2 + MediaQuery.of(context).size.width / 2,
            top: (fish['y'] as double) * MediaQuery.of(context).size.height / 2 + MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              onTap: () => _eatItem(index),
              child: Image.asset(
                  "assets/images/frog/flyfly.png",
                  width: fish['width'] / 1.0
              ),
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
              "count": _fishCount,
              "barColor": Color(0xFFFF835C),
              "imgUrl": "assets/images/frog/flyfly.png"
            }),
          ),
        ),
        _isStart
            ? SizedBox.shrink()
            : Container(
          color: Colors.black.withOpacity(0.6),
          child: Center(
            child: GestureDetector(
              onTap: () async {
                await startDetection() ;
                setState(() {
                  _isStart = true;
                });
              },
              child: Image.asset(
                "assets/images/whale/start_button.png",
                width: 200,
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

      int randomIndex = _availableIndexes[random.nextInt(_availableIndexes.length)];
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

