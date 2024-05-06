import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggomal/screens/kids/bingo.dart';
import 'package:ggomal/router.dart';
import 'package:intl/date_symbol_data_local.dart';

// 메인
void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

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
