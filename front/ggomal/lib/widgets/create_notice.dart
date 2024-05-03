import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';

class CreateNoticeModal extends StatefulWidget {
  const CreateNoticeModal({super.key});

  @override
  State<CreateNoticeModal> createState() => _CreateNoticeModalState();
}

class _CreateNoticeModalState extends State<CreateNoticeModal> {
  @override
  Widget build(BuildContext context) {

    Container lineBox(double heghtSize, String text, Widget lineWidget) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: heghtSize,
        child: Row(
          children: [
            SizedBox(
                width: 150,
                child: Text(text, style: nanumText(16.0, FontWeight.w900, Colors.black))),
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
                  children: [1, 2, 3]
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
                                child: Center(child: Text("$e")),
                              ),
                              Expanded(
                                child: TextField(
                                  style: nanumText(14.0, FontWeight.w500, Colors.black),
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
                    onPressed: () {Navigator.pop(context);},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFAA8D),
                      foregroundColor: Colors.white,
                    ),
                    child: Text("등록"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {Navigator.pop(context);},
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
}
