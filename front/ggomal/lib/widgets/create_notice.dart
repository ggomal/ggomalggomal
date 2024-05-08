import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/notice_dio.dart';

class CreateNoticeModal extends StatefulWidget {
  final String? kidId;
  const CreateNoticeModal(this.kidId, {super.key});

  @override
  State<CreateNoticeModal> createState() => _CreateNoticeModalState();
}

class _CreateNoticeModalState extends State<CreateNoticeModal> {
  final TextEditingController _contentsController = TextEditingController();
  final TextEditingController _homeworks1Controller = TextEditingController();
  final TextEditingController _homeworks2Controller = TextEditingController();
  final TextEditingController _homeworks3Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> homeworks = [
      {'number': 1, 'controller': _homeworks1Controller},
      {'number': 2, 'controller': _homeworks2Controller},
      {'number': 3, 'controller': _homeworks3Controller},
    ];

    Container lineBox(double heghtSize, String text, Widget lineWidget) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: heghtSize,
        child: Row(
          children: [
            SizedBox(
                width: 150,
                child: Text(text,
                    style: nanumText(16.0, FontWeight.w900, Colors.black))),
            lineWidget,
          ],
        ),
      );
    }

    InputDecoration inputStyle(String text) {
      return InputDecoration(
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(5),
        ),
        border: InputBorder.none,
        hintText: text,
        hintStyle: TextStyle(
          fontFamily: 'NanumS',
          color: Colors.grey.shade400,
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                blurRadius: 5.0,
                offset: Offset(3, 3),
              ),
            ],
          ),
          width: 800,
          height: 600,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
          child: Column(
            children: [
              Text(
                DateTime.now().toString().split(" ")[0],
                style: nanumText(20, FontWeight.w900, Colors.black),
              ),
              lineBox(
                240,
                "선생님 한마디",
                Expanded(
                  child: TextField(
                    controller: _contentsController,
                    style: nanumText(14.0, FontWeight.w500, Colors.black),
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    decoration: inputStyle("오늘의 알림장을 기록해주세요."),
                  ),
                ),
              ),
              lineBox(
                200,
                "숙제",
                Column(
                  children: homeworks
                      .map(
                        (e) => Container(
                          padding: const EdgeInsets.all(10),
                          height: 60,
                          width: 530,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(child: Text("${e['number']}")),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: e['controller'],
                                  style: nanumText(
                                      14.0, FontWeight.w500, Colors.black),
                                  textAlignVertical: TextAlignVertical.bottom,
                                  decoration: inputStyle("숙제를 입력하세요."),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      String response = await postNotice(
                          widget.kidId as String,
                          _contentsController.text,
                          [...homeworks.map((e) => e['controller'].text)]);
                      Navigator.pop(context, response);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFAA8D),
                      foregroundColor: Colors.white,
                    ),
                    child: Text("등록"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, "알림장 등록을 취소하였습니다.");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFAA8D),
                      foregroundColor: Colors.white,
                    ),
                    child: Text("취소"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contentsController.dispose();
    _homeworks1Controller.dispose();
    _homeworks2Controller.dispose();
    _homeworks3Controller.dispose();
    super.dispose();
  }
}
