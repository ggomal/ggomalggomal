import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ggomal/utils/navbar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';
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
                    child: YoloVideo(vision: vision),
                  )),
              FrogGame(),
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

  final List<Map<String, dynamic>> _fishLocation = [
    {"x": -0.7, "y": -0.7, "isVisible": true},
    {"x": -0.4, "y": -0.2, "isVisible": true},
    {"x": -0.3, "y": 0.2, "isVisible": true},
    {"x": -0.2, "y": -0.4, "isVisible": true},
    {"x": -0.1, "y": -0.6, "isVisible": true},
    {"x": 0.1, "y": -0.5, "isVisible": true},
    {"x": 0.4, "y": 0.2, "isVisible": true},
    {"x": 0.5, "y": -0.4, "isVisible": true},
    {"x": -0.6, "y": 0.3, "isVisible": true},
    {"x": 0.7, "y": -0.5, "isVisible": true},
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
          print(index);
          final Map<String, dynamic> fish = entry.value;
          print(fish);
          final random = Random();
          return fish['isVisible']
              ? Positioned(
            left: (fish['x'] as double) * MediaQuery.of(context).size.width / 2 + MediaQuery.of(context).size.width / 2,
            top: (fish['y'] as double) * MediaQuery.of(context).size.height / 2 + MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              onTap: () => _eatItem(index),
              child: Image.asset(
                "assets/images/frog/flyfly.png",
                width: random.nextInt(70) + 50,
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
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    controller = CameraController(
        frontCamera,
        ResolutionPreset.ultraHigh
    );

    // before
    // controller.initialize().then((value) {
    //   loadYoloModel().then((value) {
    //     setState(() {
    //       isLoaded = true;
    //       isDetecting = false;
    //       yoloResults = [];
    //     });
    //   });
    // });

    // after
    await controller.initialize();
    await loadYoloModel();
    await startDetection();

    setState(() {
      isLoaded = true;
      yoloResults = [];
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
        // ...displayBoxesAroundRecognizedObjects(size),
        // Positioned(
        //   bottom: 75,
        //   width: MediaQuery.of(context).size.width,
        //   child: Container(
        //     height: 80,
        //     width: 80,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       border: Border.all(
        //           width: 5, color: Colors.white, style: BorderStyle.solid),
        //     ),
        //     child: isDetecting
        //         ? IconButton(
        //       onPressed: () async {
        //         stopDetection();
        //       },
        //       icon: const Icon(
        //         Icons.stop,
        //         color: Colors.red,
        //       ),
        //       iconSize: 50,
        //     )
        //         : IconButton(
        //       onPressed: () async {
        //         await startDetection();
        //       },
        //       icon: const Icon(
        //         Icons.play_arrow,
        //         color: Colors.white,
        //       ),
        //       iconSize: 50,
        //     ),
        //   ),
        // ),
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
    int rotation = 0; // 기본 회전 값
    if (controller.description.sensorOrientation == 90) {
      rotation = 90;
    } else if (controller.description.sensorOrientation == 270) {
      rotation = 270;
    }

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
        print("===============================혀야 !!!!!!!!!!!!!!");
        print(result);
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
    print("##################################");
    print("멈춤");
    print("####################################");


    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

}

// class MirrorScreen extends StatefulWidget {
//   final CameraDescription camera;
//
//   const MirrorScreen({Key? key, required this.camera}) : super(key: key);
//
//   @override
//   MirrorScreenState createState() => MirrorScreenState();
// }
//
// class MirrorScreenState extends State<MirrorScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(
//       widget.camera,
//       ResolutionPreset.high,
//       enableAudio: false
//     );
//     _initializeControllerFuture = _controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 child: CameraPreview(_controller)
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }


// class TongueDetection extends StatefulWidget {
//   const TongueDetection({super.key});
//
//   @override
//   State<TongueDetection> createState() => _TongueDetectionState();
// }
//
// class _TongueDetectionState extends State<TongueDetection> {
//
//   late FlutterVision vision;
//   Options option = Options.none;
//
//   @override
//   void initState() {
//     super.initState();
//     vision = FlutterVision();
//   }
//
//   @override
//   void dispose() async {
//     super.dispose();
//     await vision.closeTesseractModel();
//     await vision.closeYoloModel();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return YoloVideo(vision: vision);
//   }
// }


