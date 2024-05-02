import 'package:flutter/material.dart';
import 'package:ggomal/widgets/chick_game.dart';
import 'package:ggomal/utils/navbar.dart';

class ChickScreen extends StatelessWidget {
  const ChickScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    {
                      'isOpen': true,
                      'img': 'chick_pizza',
                      'game': 'pizza',
                      'title': '피자를 완성해주세요 !',
                      'content': '재료를 말하면 피자위에 재료가 올라갑니다.\n요리사가 되어 피자를 만들어 보아요.'
                    },
                    {
                      'isOpen': true,
                      'img': 'chick_clean',
                      'game': 'clean',
                      'title': '집을 청소해주세요 !',
                      'content': '침대 위 물건을 말하면 물건이 사라져요.\n물건을 하나씩 불러서 집을 청소해주세요.'
                    },
                    {'isOpen': false, 'img': 'egg', 'game': ''},
                    {'isOpen': false, 'img': 'egg', 'game': ''},
                  ]
                      .map(
                        (e) =>
                        e['isOpen'] as bool ?
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  ChickGameModal({'game': e['game'], 'title': e['title'], 'content': e['content']}),
                            );
                          },
                          child:
                          Image.asset(
                            width: 150.0,
                            'assets/images/chick/${e['img']}.png',
                          ),
                        ) : Image.asset(
                          width: 150.0,
                          'assets/images/chick/${e['img']}.png',
                        ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
