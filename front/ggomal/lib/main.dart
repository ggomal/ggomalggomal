import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggomal/screens/kids/bingo.dart';
import 'package:ggomal/router.dart';

// 메인
void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RoomId(),
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
