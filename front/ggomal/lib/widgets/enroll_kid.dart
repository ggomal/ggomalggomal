import 'package:flutter/material.dart';

class EnrollKidModal extends StatefulWidget {
  const EnrollKidModal({super.key});

  @override
  State<EnrollKidModal> createState() => _EnrollKidModalState();
}

class _EnrollKidModalState extends State<EnrollKidModal> {
  DateTime? _birthDate = DateTime.now();

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
        // color: Colors.red,
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
                offset: Offset(3, 3), // changes position of shadow
              ),
            ],
          ),
          width: 350,
          height: 600,
          padding: const EdgeInsets.all(40),
          child: Column(children: [
            lineBox(50, "이름", Expanded(child: TextField(decoration: InputDecoration(
            )))),
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
            lineBox(50, "성별", Text("임시")),
            lineBox(150, "사진", Text("사진들어갈 칸")),
            lineBox(50, "특이사항", Expanded(child: TextField())),
            lineBox(
                100,
                "보호자",
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("관계"), Text("연락처")],
                )),
          ]),
        ),
      ),
    );
  }
}
