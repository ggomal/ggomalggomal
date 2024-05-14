//경로 관련
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ggomal/screens/kids/chick_clean.dart';
import 'package:ggomal/screens/kids/chick_pizza.dart';
import 'package:ggomal/screens/manager/kid_detail.dart';
import 'package:ggomal/screens/manager/kids_manage.dart';
import 'package:ggomal/screens/manager/manager_calendar.dart';
import 'package:ggomal/screens/manager/manager_main.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/screens/kids/whale.dart';
import 'package:ggomal/screens/login.dart';
import 'package:ggomal/screens/start.dart';
import 'package:ggomal/screens/kids/main.dart';
import 'package:ggomal/screens/kids/bear.dart';
import 'package:ggomal/widgets/frog_game.dart';
import 'package:ggomal/screens/kids/chick.dart';
import 'package:ggomal/screens/kids/home.dart';
import 'package:ggomal/screens/kids/bingo.dart';
import 'package:ggomal/widgets/kid_report.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/start', builder: (context, state) => const StartScreen()),
    GoRoute(
      path: '/kids',
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
      path: '/kids/chick/pizza',
      builder: (context, state) => const ChickPizzaScreen(),
    ),
    GoRoute(
      path: '/kids/frog',
      builder: (context, state) => const FrogTown(),
    ),
    GoRoute(
      path: '/kids/home',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/kids/bear/bingo',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          throw Exception('No data passed to route');
        }
        final channel = extra['channel'] as WebSocketChannel?;
        final responseData = extra['bingoBoardData'] as List<List<Map<String, dynamic>>>?;

        if (channel == null) {
          throw Exception('WebSocketChannel is required for BingoScreen');
        }

        return MaterialPage(
          key: state.pageKey,
          child: BingoScreen(
            responseData: responseData,
            channel: channel,
          ),
        );
      },
    ),

    GoRoute(
      path: '/kids/chick/clean',
      builder: (context, state) => const ChickCleanScreen(),
    ),
    //
    GoRoute(
      path: '/manager',
      builder: (context, state) => const ManagerMainScreen(),
    ),
    GoRoute(
      path: '/manager/kids',
      builder: (context, state) => const KidsManageScreen(),
    ),
    GoRoute(
      path: '/manager/kids/:id',
      builder: (context, state) {
        return KidDetail(state.pathParameters['id']);
        // return KidDetail();
      },
    ),
    GoRoute(
      path: '/manager/calender',
      builder: (context, state) => const ManagerCalendarScreen(),
    ),
  ],
);