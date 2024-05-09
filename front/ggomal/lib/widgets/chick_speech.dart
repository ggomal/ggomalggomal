import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/chick_dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';

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
  String filePath = '';

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

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
      String m4a = filePath.replaceAll('.aac', '.m4a');
      await audioFile.rename(m4a);
      final response = await checkAudio(1, "${widget.speechData['name']} ${widget.speechData['ending']}", m4a);
      print(response);

    }else{
      print("파일이 존재하지 않습니다.");
    }
  }

  Future<void> record() async {
    Directory tempDir = await getTemporaryDirectory();
    filePath = '${tempDir.path}/chick_audio_$recordCount.aac';

    await recorder.startRecorder(toFile: filePath);

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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> speechData = widget.speechData;
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.6;
    double height = screenSize.height * 0.7;

    return Dialog(
      child: Stack(
        children: [
          Image.asset("assets/images/chick/chick_modal.png",
              width: width, height: height, fit: BoxFit.fill),
          Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  child: Row(children: [
                    Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 250,
                          child: Center(
                            child: Image.asset(
                                "assets/images/chick/${speechData['game']}_thing_${speechData['img']}.png"),
                          ),
                        )),
                    Flexible(
                      flex: 2,
                      child: Center(
                          child: Text(
                              "${speechData['name']} ${speechData['ending']}",
                              style: mapleText(
                                  60, FontWeight.w700, Colors.black))),
                    ),
                  ]),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (recorder.isRecording) {
                      await stop();
                    } else {
                      await record();
                    }
                  },
                  child: Text(recorder.isRecording ? '끝내기' : '말하기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
