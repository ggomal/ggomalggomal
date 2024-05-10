import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../const/keys.dart';
import '../../utils/navbar.dart';
import '../../widgets/percent_bar.dart';

class FrogScreen extends StatefulWidget {
  const FrogScreen({Key? key}) : super(key: key);

  @override
  State<FrogScreen> createState() => _FrogScreenState();
}

class _FrogScreenState extends State<FrogScreen> {
  late final CameraDescription camera;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    camera = frontCamera;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(),
      body:
      FutureBuilder<void>(
        future: init(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Stack(
            children: [
              Positioned(
                // bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: MirrorScreen(camera: camera),
                  )),
              FrogGame(),
            ],
          );
        }
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
          return fish['isVisible']
              ? Positioned(
            left: (fish['x'] as double) * MediaQuery.of(context).size.width / 2 + MediaQuery.of(context).size.width / 2,
            top: (fish['y'] as double) * MediaQuery.of(context).size.height / 2 + MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              onTap: () => _eatItem(index),
              child: Image.asset(
                "assets/images/frog/flyfly.png",
                width: 70,
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
              "imgUrl": "assets/images/frog/fruits.png"
            }),
          ),
        )
      ],
    );
  }
}

class MirrorScreen extends StatefulWidget {
  final CameraDescription camera;

  const MirrorScreen({Key? key, required this.camera}) : super(key: key);

  @override
  MirrorScreenState createState() => MirrorScreenState();
}

class MirrorScreenState extends State<MirrorScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Timer? _timer;
  bool _isCapturing = false;
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8080/api/images/upload',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false
    );
    _initializeControllerFuture = _controller.initialize();
    _startStreamingImages();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startStreamingImages() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (_isCapturing) return;

      _isCapturing = true;
      try {
        final image = await _captureAndSaveImage();
        await _sendImageToServer(image);
      } catch (e) {
        print("Error capturing/sending image: $e");
      } finally {
        _isCapturing = false;
      }
    });
  }

  Future<File> _captureAndSaveImage() async {
    final XFile imageFile = await _controller.takePicture();
    final directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/mirror_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File image = File(filePath);
    await imageFile.saveTo(filePath);

    return image;
  }


  Future<void> _sendImageToServer(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path),
      });
      final response = await _dio.post('', data: formData);
      if (response.statusCode == 200) {
        print("Image sent successfully");
      } else {
        print("Failed to send image: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending image: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(_controller)
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


