import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/get_storage.dart';
import 'package:get/get.dart';
import 'package:ggomal/widgets/kid_report.dart';
import 'package:audioplayers/audioplayers.dart';

import '../utils/notification_dialog.dart';
import '../utils/room_furniture.dart';

class NavBarHome extends StatelessWidget implements PreferredSizeWidget {
  const NavBarHome({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {


    Get.put(CoinController());
    TextStyle baseText(double size, FontWeight weight) {
      return TextStyle(
        fontFamily: 'Maplestory',
        fontWeight: weight,
        fontSize: size,
        color: Colors.black,
      );
    }

    final AudioPlayer player = AudioPlayer();

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
                player.play(AssetSource('audio/touch.mp3'));
                context.go('/kids');
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                child: Image.asset('assets/images/home_button.png',
                    fit: BoxFit.contain),
              ),
            ),
            GestureDetector(
              onTap: () {
                player.play(AssetSource('audio/touch.mp3'));
                showDialog(
                    context: context, builder: (context) => FurnitureDialog());
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                child: Image.asset('assets/images/room_button.png',
                    fit: BoxFit.contain),
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
            player.play(AssetSource('audio/touch.mp3'));
            context.go('/kids/report');
          },
          child: Text('학습현황 만드는중'),
        ),
        GestureDetector(
          onTap: () {
            player.play(AssetSource('audio/touch.mp3'));
            showDialog(
                context: context, builder: (context) => NotificationDialog());
          },
          child: Container(
            child: Row(
              children: [
                Image.asset(
                  'assets/images/letter.png',
                  width: 50,
                ),
                Text(
                  ' 알림장  ',
                  style: baseText(25.0, FontWeight.w800),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            player.play(AssetSource('audio/touch.mp3'));
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Text('이건 학습현황'),
                  );
                });
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
          onTap: () {
            player.play(AssetSource('audio/touch.mp3'));
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Text('이건 보상 클릭'),
                  );
                });
          },
          child: Container(
            child: Row(
              children: [
                Image.asset('assets/images/reward.png'),
                GetX<CoinController>(builder: (controller) {
                  return Text(
                    'x ${controller.coinCount.value}',
                    style: baseText(30.0, FontWeight.w800),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
