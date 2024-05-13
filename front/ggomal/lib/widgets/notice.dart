import 'package:flutter/material.dart';

class Notice extends StatefulWidget {
  final Map<String, dynamic> notice;

  const Notice(this.notice, {super.key});

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
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


    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      width: 200,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,
          child: Center(child: Text("${widget.notice['date']}", style: baseText(18, FontWeight.w900)))),
          SizedBox(
            height: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.notice['teacherName']} 선생님이 남긴 말", style: baseText(16, FontWeight.w900)),
                Text("${widget.notice['content']}", style: baseText(14, FontWeight.normal)),
              ],
            ),
          ),

          SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("숙제", style: baseText(16, FontWeight.w900)),
                ...widget.notice['homeworks']
                    .map(
                      (e) => Text("${e['homeworkContents']}", style: baseText(14, FontWeight.normal)),
                )
                    .toList(),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
