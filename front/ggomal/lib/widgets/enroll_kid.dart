import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class EnrollKidModal extends StatefulWidget {
  const EnrollKidModal({super.key});

  @override
  State<EnrollKidModal> createState() => _EnrollKidModalState();
}

class _EnrollKidModalState extends State<EnrollKidModal> {
  DateTime? _birthDate = DateTime.now();
  int? _gender = 1;

  @override
  Widget build(BuildContext context) {
    TextStyle baseText(double size, FontWeight weight) {
      return TextStyle(
        fontFamily: 'NanumS',
        fontWeight: weight,
        fontSize: size,
        color: Colors.black,
      );
    }

    Container lineBox(double heghtSize, String text, Widget lineWidget) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: heghtSize,
        child: Row(
          children: [
            SizedBox(
                width: 80,
                child: Text(text, style: baseText(16.0, FontWeight.w900))),
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
          color: Colors.grey.shade400, // 라벨 텍스트 색상
          fontSize: 14.0, // 라벨 텍스트 크기
          fontWeight: FontWeight.bold, // 라벨 텍스트 굵기
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
          width: 400,
          height: 600,
          padding: const EdgeInsets.all(40),
          child: Column(children: [
            lineBox(
                50,
                "이름",
                Expanded(
                  child: TextField(
                    style: baseText(14.0, FontWeight.w500),
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: inputStyle("이름을 입력해 주세요."),
                  ),
                )),
            lineBox(
                50,
                "생년월일",
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    ).then((birthDate) => {
                          setState(() {
                            _birthDate = birthDate;
                          })
                        });
                  },
                  child: Text(_birthDate.toString().split(" ")[0]),
                )),
            lineBox(
              50,
              "성별",
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton(
                      value: _gender,
                      items: [
                        DropdownMenuItem(value: 1, child: Text("여자")),
                        DropdownMenuItem(value: 2, child: Text("남자")),
                      ],
                      onChanged: (int? value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      style: baseText(14, FontWeight.w500),
                      dropdownColor: Color(0xFFF5F5F5),
                      underline: Container(),
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
            ),
            lineBox(
                150,
                "사진",
                Container(
                    width: 120,
                    height: 150,
                    color: Color(0xFFF5F5F5),
                    child: Center(child: Text("사진 찍기")))),
            lineBox(
                50,
                "특이사항",
                Expanded(
                    child: TextField(
                  style: baseText(14.0, FontWeight.w500),
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: inputStyle("특이사항을 입력해 주세요."),
                ))),
            lineBox(
                100,
                "보호자",
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 240,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(children: [
                            SizedBox(
                              width: 50,
                              child: Text("관계",
                                  style: baseText(16, FontWeight.w900)),
                            ),
                            Expanded(
                                child: TextField(
                              style: baseText(14.0, FontWeight.w500),
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: inputStyle("관계를 입력해 주세요."),
                            ))
                          ]),
                        )),
                    SizedBox(
                        width: 240,
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(children: [
                            SizedBox(
                              width: 50,
                              child: Text("연락처",
                                  style: baseText(16, FontWeight.w900)),
                            ),
                            Expanded(
                                child: TextField(
                              style: baseText(14.0, FontWeight.w500),
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: inputStyle("연락처를 입력해 주세요."),
                            ))
                          ]),
                        )),
                  ],
                )),
            SizedBox(
              height: 20,
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
          ]),
        ),
      ),
    );
  }
}
