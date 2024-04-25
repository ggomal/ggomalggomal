//경로 관련
import 'package:go_router/go_router.dart';
import 'package:ggomal/screens/kids/whale.dart';
import 'package:ggomal/screens/login.dart';
import 'package:ggomal/screens/kids/main.dart';
import 'package:ggomal/screens/kids/bear.dart';
import 'package:ggomal/screens/kids/frog.dart';
import 'package:ggomal/screens/kids/chick.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/kids/main',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/kids/whale',
      builder: (context, state) => const WhaleScreen(),
    ),
    GoRoute(
      path: '/kids/bear',
      builder: (context, state) => const BearScreen(),
    ),
    GoRoute(
      path: '/kids/chick',
      builder: (context, state) => const ChickScreen(),
    ),
    GoRoute(
      path: '/kids/frog',
      builder: (context, state) => const FrogScreen(),
    ),
  ],
);