import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/widgets/kid_report.dart';

class NavBarHome extends StatelessWidget implements PreferredSizeWidget {
  const NavBarHome({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    TextStyle baseText(double size, FontWeight weight) {
      return TextStyle(
        fontFamily: 'Maplestory',
        fontWeight: weight,
        fontSize: size,
        color: Colors.black,
      );
    }

    return AppBar(
      backgroundColor: Color(0xffFFFEF1),
      toolbarHeight: preferredSize.height,
      leadingWidth: 320,
      centerTitle: true,
      leading: SizedBox(
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.go('/kids');
              },
                child:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                      child: Image.asset('assets/images/home_button.png', fit: BoxFit.contain),
                    ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context){
                      return Dialog(
                        child: Text('방꾸미기 모달'),
                      );
                    }
                );
              },
                child:
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                  child: Image.asset('assets/images/room_button.png', fit: BoxFit.contain),
                ),
            ),
          ],
        ),
      ),

      title: Container(
        height: kToolbarHeight + 20,
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            context.go('/kids/report');
          },
          child: Text('학습현황 만드는중'),
        ),
        GestureDetector(
          onTap: (
              ){
            showDialog(
                context: context,
                builder: (context){
              return Dialog(
                child: Text('알림장이라고 하자'),
              );
            }
            );
          },
          child: Container(
            child: Row(
              children: [
                Image.asset('assets/images/letter.png', width: 50,),
                Text(
                  ' 알림장  ',
                  style: baseText(25.0, FontWeight.w800),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (
              ){
            showDialog(
                context: context,
                builder: (context){
                  return Dialog(
                    child: Text('이건 학습현황'),
                  );
                }
            );
          },
          child: Container(
            child: Row(
              children: [
                Image.asset('assets/images/flower.png', width: 50),
                Text(
                  '학습현황  ',
                  style: baseText(25.0, FontWeight.w800),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (
              ){
            showDialog(
                context: context,
                builder: (context){
                  return Dialog(
                    child: Text('이건 보상 클릭'),
                  );
                }
            );
          },
          child: Container(
            child: Row(
              children: [
                Image.asset('assets/images/reward.png'),
                Text(
                  'x 4  ',
                  style: baseText(25.0, FontWeight.w800),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
