import 'package:flutter/material.dart';
import 'package:ggomal/states/furniture_state.dart';
import 'package:ggomal/states/future_provider.dart';
import 'package:provider/provider.dart';
import 'package:ggomal/router.dart';
import 'package:intl/date_symbol_data_local.dart';

// 메인
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FurnitureProvider()),
      ],
      child: _App(),
    ),
  );
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
