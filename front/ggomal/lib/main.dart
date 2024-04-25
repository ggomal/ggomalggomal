import 'package:flutter/material.dart';
import 'package:ggomal/router.dart';

// 메인
void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return
      MaterialApp.router(
      routerConfig: router,
    );
  }
}
