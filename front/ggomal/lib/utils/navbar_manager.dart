import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/screens/kids/main.dart';

class ManagerNavBar extends StatelessWidget implements PreferredSizeWidget {
  const ManagerNavBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2.7);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFF9F9F9),
      centerTitle: true,
      title: Container(
        height: preferredSize.height,
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),
      toolbarHeight: preferredSize.height,
    );
  }
}
