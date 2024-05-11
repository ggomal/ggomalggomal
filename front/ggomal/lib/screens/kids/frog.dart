import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../utils/navbar.dart';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_vision/flutter_vision.dart';
import '../../widgets/percent_bar.dart';

enum Options { none, imagev5, imagev8, imagev8seg, frame, tesseract, vision }
late List<CameraDescription> cameras;

class FrogScreen extends StatefulWidget {
  const FrogScreen({Key? key}) : super(key: key);

  @override
  State<FrogScreen> createState() => _FrogScreenState();
}

class _FrogScreenState extends State<FrogScreen> {
  late FlutterVision vision;
  Options option = Options.none;
  late final GlobalKey<_FrogGameState> frogGameStateKey;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    super.initState();
    vision = FlutterVision();
    frogGameStateKey = GlobalKey<_FrogGameState>();
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

class FrogGame extends StatefulWidget {
  const FrogGame({Key? key}) : super(key: key);

  @override
  State<FrogGame> createState() => _FrogGameState();
}

class _FrogGameState extends State<FrogGame> {
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

  void _eatFish() {
    setState(() {
      _fishCount += 1;
    });
  }

  void _eatItem(int index) {
    setState(() {
      _fishCount += 1;
      _fishLocation[index]['isVisible'] = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
          alignment: Alignment.bottomRight,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _eatFish,
              child: Text('Eat Fish'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Text("Fish count: $_fishCount"),
          ),
        ),
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
        )
      ],
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

  void _eatFish() {
    setState(() {
      _fishCount += 1;
    });
  }

  void _eatItem(int index) {
    setState(() {
      _fishCount += 1;
      _fishLocation[index]['isVisible'] = false;
      _availableIndexes.remove(index); // 인덱스 사용 후 제거
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
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          // isDetecting = false; <------------여기
          yoloResults = [];
        });
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
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 5, color: Colors.white, style: BorderStyle.solid),
            ),
            child: isDetecting
                ? IconButton(
              onPressed: () async {
                stopDetection();
              },
              icon: const Icon(
                Icons.stop,
                color: Colors.red,
              ),
              iconSize: 50,
            )
                : IconButton(
              onPressed: () async {
                await startDetection();
              },
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              iconSize: 50,
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
          alignment: Alignment.bottomRight,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: _eatFish,
              child: Text('Eat Fish'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Text("Fish count: $_fishCount"),
          ),
        ),
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
        )

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
        yoloResults = result;
        print("============================= 혀임 !!!!!!!!!!");
        print(result);

        // 감지를 일시 중지합니다.
        isDetecting = false;
        yoloResults.clear();
        controller.stopImageStream();

        int randomIndex = _availableIndexes[random.nextInt(_availableIndexes.length)];
        _eatItem(randomIndex);

        // 2초 후에 다시 감지 시작
        Future.delayed(Duration(seconds: 5), () {
          startDetection();
        });
      });
    }
  }

  Future<void> startDetection() async {
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
      yoloResults.clear();
    });
  }

}


