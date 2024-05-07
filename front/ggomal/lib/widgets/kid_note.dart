import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ggomal/services/notice_dio.dart';
import 'package:ggomal/widgets/check.dart';
import 'package:ggomal/widgets/create_notice.dart';
import 'package:ggomal/widgets/notice.dart';

class KidNote extends StatefulWidget {
  const KidNote({super.key});

  @override
  State<KidNote> createState() => _KidNoteState();
}

class _KidNoteState extends State<KidNote> {
  late Future<List> _noticeListFuture;

  @override
  void initState() {
    super.initState();
    _noticeListFuture = getNoticeList(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => CreateNoticeModal(),
              ).then(
                (response) => {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          CheckModal(response)).then((value) => {
                        setState(() {
                          _noticeListFuture = getNoticeList(1);
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
