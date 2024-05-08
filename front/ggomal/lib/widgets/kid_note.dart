import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/notice_dio.dart';
import 'package:ggomal/widgets/check.dart';
import 'package:ggomal/widgets/create_notice.dart';
import 'package:ggomal/widgets/notice.dart';

class KidNote extends StatefulWidget {
  final String? kidId;
  const KidNote(this.kidId, {super.key});

  @override
  State<KidNote> createState() => _KidNoteState();
}

class _KidNoteState extends State<KidNote> {
  late Future<List> _noticeListFuture;
  late int thisMonth;
  late int month;

  @override
  void initState() {
    super.initState();
    month = DateTime.now().month;
    thisMonth = DateTime.now().month;
    _noticeListFuture = getNoticeList(widget.kidId as String, month);
  }

  void changeMonth(int num) {
    setState((){
      month =  ((month + num) % 12) <= 0 ? (month + num) % 12 + 12 : (month + num) % 12;
      _noticeListFuture = getNoticeList(widget.kidId as String, month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 20.0),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  month % 12 == (thisMonth + 1) % 12 ? SizedBox(width: 50,) : IconButton(
                    padding: const EdgeInsets.all(0),
                    iconSize: 50,
                    icon: Icon(Icons.arrow_left),
                    onPressed: (){changeMonth(-1);},
                  ),
                  Text("$month월", style: nanumText(28, FontWeight.w900, Colors.black)),
                  month == thisMonth ? SizedBox(width: 50,) : IconButton(
                    padding: const EdgeInsets.all(0),
                    iconSize: 50,
                    icon: Icon(Icons.arrow_right),
                    onPressed: (){changeMonth(1);},
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => CreateNoticeModal(widget.kidId),
                  ).then(
                    (response) => {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CheckModal(response)).then((value) => {
                            setState(() {
                              _noticeListFuture = getNoticeList(widget.kidId as String, month);
                            })
                          }),
                    },
                  ),
                  child: Image.asset(
                    "assets/images/manager/add_button.png",
                    width: 40,
                  ),
                )
              ]),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: FutureBuilder<List<dynamic>>(
            future: _noticeListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Text('데이터 로딩 실패');
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Notice(snapshot.data![index]);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
