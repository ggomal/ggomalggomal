import 'package:flutter/material.dart';

class CreateBingoModal extends StatefulWidget {
  const CreateBingoModal({super.key});

  @override
  State<CreateBingoModal> createState() => _CreateBingoModalState();
}

class _CreateBingoModalState extends State<CreateBingoModal> {
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

    return Dialog(
        child: SizedBox(
      width: 300,
      height: 500,
      child: Column(
        children: [
          Text(
            '아이 현황',
            style: baseText(23, FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                ),
                Text(
                  '김이안',
                  style: baseText(18.0, FontWeight.bold),
                ),
                Text(
                  '온라인',
                  style: baseText(
                    15,
                    FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
          Text(
            '단어 묶음 선택',
            style: baseText(23, FontWeight.bold),
          ),
          Text(
            '음절',
            style: baseText(18, FontWeight.normal),
          ),
          Container(height: 50, color: Colors.blue),
          Text('초성'),
          Container(height: 50, color: Colors.red),
          ElevatedButton(onPressed: () {}, child: Text('시작하기'))
        ],
      ),
    ));
  }
}
