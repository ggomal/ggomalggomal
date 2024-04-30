import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateBingoModal extends StatefulWidget {
  const CreateBingoModal({super.key});

  @override
  State<CreateBingoModal> createState() => _CreateBingoModalState();
}

class _CreateBingoModalState extends State<CreateBingoModal> {
  final List<String> words = [
    '1음절',
    '2음절',
    '받침이 없는 단어',
    '받침이 있는 단어',
    '구',
    '문장'
  ];
  final List<String> initials = [
    'ㅍ, ㅁ, ㅇ',
    'ㄷ, ㅌ, ㄴ',
    'ㄱ, ㅋ, ㅈ, ㅊ',
    'ㅅ',
    '받침 ㄹ',
    '초성 ㄹ'
  ];
  String? _selectedWords;
  String? _selectedInitials;

  @override
  void initState() {
    super.initState();
    _selectedWords = words.first;
    _selectedInitials = initials.first;
  }

  TextStyle baseText(double size, FontWeight weight) {
    return TextStyle(
      fontFamily: 'NanumS',
      fontWeight: weight,
      fontSize: size,
      color: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Stack(
      children: [
        Container(
          width: 400,
          height: 530,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(40, 40, 0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '아이 현황',
                    style: baseText(25, FontWeight.w900),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Icon(
                          Icons.circle,
                          size: 18,
                          color: Colors.green,
                          // color : Colors.grey
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '김이안',
                            style: baseText(20.0, FontWeight.bold),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          '온라인',
                          style: baseText(
                            17,
                            FontWeight.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 50, 0, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '단어 묶음 선택',
                    style: baseText(25, FontWeight.w900),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 5, 0, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '음절',
                    style: baseText(20, FontWeight.normal),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedWords,
                      isExpanded: true,
                      style: TextStyle(
                        fontFamily: 'NanumS',
                        fontSize: 20,
                        color: Color(0xFF767676),
                      ),
                      underline: SizedBox.shrink(),
                      icon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      items:
                          words.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              value,
                              style: TextStyle(
                                color: value == _selectedWords ? Colors.black : null, fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedWords = newValue;
                        });
                      },
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 15, 0, 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '초성',
                    style: baseText(20, FontWeight.normal),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedInitials,
                      isExpanded: true,
                      style: TextStyle(
                        fontFamily: 'NanumS',
                        fontSize: 20,
                        color: Color(0xFF767676),
                      ),
                      underline: SizedBox.shrink(),
                      icon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.arrow_drop_down,
                            size: 40, color: Colors.grey),
                      ),
                      items: initials.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: value == _selectedInitials ? Colors.black : null, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedInitials = newValue;
                        });
                      },
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFAA8D),
                      foregroundColor: Color(0xffFF5B20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      '시작하기',
                      style: baseText(20, FontWeight.bold),
                    ),
                  ))
            ],
          ),
        ),
        Positioned(
          top: 15,
          right: 15,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(
              'assets/images/manager/close_button.png',
              width: 35,
            ),
          ),
        )
      ],
    )
    );
  }
}
