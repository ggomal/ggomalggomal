import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/screens/kids/main.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xffFFFEF1),
      toolbarHeight: preferredSize.height,
      leadingWidth: 150,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          context.go('/kids');
        },
        child: Container(
          child: Image.asset('assets/images/home_button.png', fit: BoxFit.contain),
        ),
      ),
      title: Container(
        height: kToolbarHeight+20,
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        Image.asset('assets/images/reward.png'),
        Text('개수')
      ],
    );
  }
}
