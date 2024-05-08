import 'package:flutter/material.dart';
import 'package:ggomal/services/kid_manage_dio.dart';
import 'package:ggomal/widgets/kid_image.dart';
import 'package:ggomal/constants.dart';
import 'dart:io';

class EnrollKidModal extends StatefulWidget {
  const EnrollKidModal({super.key});

  @override
  State<EnrollKidModal> createState() => _EnrollKidModalState();
}

class _EnrollKidModalState extends State<EnrollKidModal> {
  DateTime? _birthDate = DateTime.now();
  String? _gender = "FEMALE";
  File? _selectedImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Container lineBox(double heghtSize, String text, Widget lineWidget) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        height: heghtSize,
        child: Row(
          children: [
            SizedBox(
                width: 80,
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
          hintStyle: nanumText(14.0, FontWeight.bold, Colors.grey.shade400));
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
                    controller: _nameController,
                    style: nanumText(14.0, FontWeight.w500, Colors.black),
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
                    ).then((birthDate) =>
                    {
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
                        DropdownMenuItem(value: "FEMALE", child: Text("여자")),
                        DropdownMenuItem(value: "MALE", child: Text("남자")),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      style: nanumText(14, FontWeight.w500, Colors.black),
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
              SizedBox(
                height: 150,
                child: KidImage(onImageSelected: (selectedImage) {
                  setState(() {
                    _selectedImage = selectedImage;
                  });
                },),
              ),
            ),
            lineBox(
                50,
                "특이사항",
                Expanded(
                    child: TextField(
                      controller: _noteController,
                      style: nanumText(14.0, FontWeight.w500, Colors.black),
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
                              child: Text("이름",
                                  style: nanumText(
                                      16, FontWeight.w900, Colors.black)),
                            ),
                            Expanded(
                                child: TextField(
                                  controller: _parentNameController,
                                  style: nanumText(
                                      14.0, FontWeight.w500, Colors.black),
                                  textAlignVertical: TextAlignVertical.bottom,
                                  decoration: inputStyle("이름을 입력해 주세요."),
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
                                  style: nanumText(
                                      16, FontWeight.w900, Colors.black)),
                            ),
                            Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  style: nanumText(
                                      14.0, FontWeight.w500, Colors.black),
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
                  onPressed: () async {
                    String response = await signUpKid(
                        _nameController.text,
                        _birthDate!,
                        _gender!,
                        _selectedImage,
                        _noteController.text,
                        _parentNameController.text,
                        _phoneController.text);
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
                    Navigator.pop(context, "아이 등록을 취소하였습니다.");
                  },
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