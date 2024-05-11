import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/get_storage.dart';
import 'package:get/get.dart';
import 'package:ggomal/screens/kids/main.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

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

    return AppBar(
      backgroundColor: Color(0xffFFFEF1),
      toolbarHeight: preferredSize.height,
      leadingWidth: 150,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          context.go('/kids');
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child:
              Image.asset('assets/images/home_button.png', fit: BoxFit.contain),
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
        Image.asset('assets/images/reward.png'),
        GetX<CoinController>(builder: (controller) {
          return Text(
            'x ${controller.coinCount.value}',
            style: baseText(30.0, FontWeight.w800),
          );
        }),
      ],
    );
  }
}
