import 'package:flutter/material.dart';
import 'package:ggomal/states/furniture_state.dart';
import 'package:ggomal/states/future_provider.dart';
import 'package:provider/provider.dart';
import 'package:ggomal/router.dart';
import 'package:audioplayers/audioplayers.dart';
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

class _App extends StatefulWidget {
  const _App({super.key});

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  final AudioPlayer _backgroundPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _backgroundPlayer.setVolume(0.1);
    _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    _backgroundPlayer.play(AssetSource('audio/bg.mp3'));
  }


  @override
  void dispose() {
    _backgroundPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
