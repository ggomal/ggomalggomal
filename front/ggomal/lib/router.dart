//경로 관련
import 'package:ggomal/screens/kids/chick_clean.dart';
import 'package:ggomal/screens/kids/chick_pizza.dart';
import 'package:ggomal/screens/manager/kid_detail.dart';
import 'package:ggomal/screens/manager/kids_manage.dart';
import 'package:ggomal/screens/manager/manager_main.dart';
import 'package:go_router/go_router.dart';
import 'package:ggomal/screens/kids/whale.dart';
import 'package:ggomal/screens/login.dart';
import 'package:ggomal/screens/start.dart';
import 'package:ggomal/screens/kids/main.dart';
import 'package:ggomal/screens/kids/bear.dart';
import 'package:ggomal/screens/kids/frog.dart';
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
      builder: (context, state) => const BingoScreen(),
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
      builder: (context, state) => const FrogScreen(),
    ),
    GoRoute(
      path: '/kids/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/kids/bear/bingo',
      builder: (context, state) => const BingoScreen(),
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
      path: '/kids/report',
      builder: (context, state) => const KidReport(),
    ),
  ],
);