import 'package:flutter/material.dart';
import 'package:ggomal/constants.dart';
import 'package:ggomal/services/chick_dio.dart';
import 'package:ggomal/widgets/chick_game.dart';
import 'package:ggomal/utils/navbar.dart';

class ChickScreen extends StatefulWidget {
  const ChickScreen({super.key});

  @override
  State<ChickScreen> createState() => _ChickScreenState();
}

class _ChickScreenState extends State<ChickScreen> {
  late Future<List> _chickFuture;

  List<Map<String, dynamic>> gameInfoList = [
    {
      'img': 'chick_clean',
      'game': 'clean',
      'title': '집을 청소해주세요 !',
      'content': '침대 위 물건을 말하면 물건이 사라져요.\n물건을 하나씩 불러서 집을 청소해주세요.'
    },
    {
      'img': 'chick_pizza',
      'game': 'pizza',
      'title': '피자를 완성해주세요 !',
      'content': '재료를 말하면 피자위에 재료가 올라갑니다.\n요리사가 되어 피자를 만들어 보아요.'
    },
    {
      'img': 'egg',
      'game': 'clean',
      'title': '집을 청소해주세요 !',
      'content': '침대 위 물건을 말하면 물건이 사라져요.\n물건을 하나씩 불러서 집을 청소해주세요.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _chickFuture = getChick();
  }

  @override
  Widget build(BuildContext context) {
    double width = screenSize(context).width;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/chick/chick_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: NavBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 120.0,
            vertical: 10.0,
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/chick/chick_box.png',
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100.0, 150.0, 100.0, 0.0),
                child: FutureBuilder<List<dynamic>>(
                  future: _chickFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('아이 정보 로딩 실패'));
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          snapshot.data!.length,
                          (index) => snapshot.data![index]['acquired']
                              ? InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ChickGameModal({
                                        'game': gameInfoList[index]['game'],
                                        'title': gameInfoList[index]['title'],
                                        'content': gameInfoList[index]
                                            ['content']
                                      }),
                                    );
                                  },
                                  child: Image.asset(
                                    width: width * 0.13,
                                    'assets/images/chick/${gameInfoList[index]['img']}.png',
                                  ),
                                )
                              : Image.asset(
                                  width: width * 0.13,
                                  'assets/images/chick/egg.png',
                                ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
