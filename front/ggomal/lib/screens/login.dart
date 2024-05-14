import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/widgets.dart';
import 'package:ggomal/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:ggomal/login_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> with TickerProviderStateMixin {
  final Dio dio = Dio();
  final LoginStorage loginStorage = LoginStorage();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List<ParticleOptionsData> particleOptionsList = [
    ParticleOptionsData(baseColor: Colors.cyan),
    ParticleOptionsData(baseColor: Colors.yellow),
    ParticleOptionsData(baseColor: Colors.pink),
  ];

  Future<void> loginUser() async {
    try {
      Response response = await dio.post(
        'https://k10e206.p.ssafy.io/api/v1/login',
        data: {
          'id': idController.text,
          'password': passwordController.text,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        String jwt = responseData['jwt'];
        String role = responseData['role'];
        String name = responseData['name'];
        await loginStorage.setJwt(jwt);
        await loginStorage.setRole(role);
        await loginStorage.setName(name);
        // if (role == 'KID') {
        // context.go('/start');
        // } else if (role == 'TEACHER') {
        //   context.go('/manager');
        // } else {
        //   print('role이 이상함');
        // }
        if (role == 'KID') {
          context.go('/start');
        } else {
          context.go('/manager');
        }
      } else {
        print('로그인 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러: $e');
    }
  }

  InputDecoration inputStyle(String text) {

    return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.brown, width: 3),
          borderRadius: BorderRadius.circular(50),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.brown, width: 3),
          borderRadius: BorderRadius.circular(50),
        ),
        border: InputBorder.none,
        hintText: text,
        hintStyle: mapleText(20.0, FontWeight.bold, Colors.grey.shade400));
  }

  @override
  Widget build(BuildContext context) {

    double width = screenSize(context).width;
    double height = screenSize(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFEEF8FF),
      body: Stack(
        children: [
          ...particleOptionsList
              .map((data) => buildAnimatedBackground(data.particleOptions))
              .toList(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Center(
              child: SizedBox(
                width: width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width * 0.4,
                          height: height * 0.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 120,
                                      child: Text("아이디",
                                          style: mapleText(28, FontWeight.w700,
                                              Colors.brown))),
                                  SizedBox(
                                    width: width * 0.3,
                                    height: 70,
                                    child: TextField(
                                      controller: idController,
                                      decoration: inputStyle("아이디를 입력해주세요."),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                      width: 120,
                                      child: Text("비밀번호",
                                          style: mapleText(28, FontWeight.w700,
                                              Colors.brown))),
                                  SizedBox(
                                    width: width * 0.3,
                                    height: 70,
                                    child: TextField(
                                      controller: passwordController,
                                      decoration: inputStyle("비밀번호를 입력해주세요."),
                                      // obscureText: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: loginUser,
                          child: Image.asset(
                            'assets/images/login_button.png',

                            height: 150,
                          ),
                        )
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     OutlinedButton(
                    //       //이거 주석 풀면 아이/선생님 로그인 검사 들어감
                    //       onPressed: loginUser,
                    //       //이거 주석 풀면 로그인 없이 바로 키즈 페이지랑 관리자 접속됨
                    //       // onPressed: () {context.go('/start');},
                    //       child: Text("로그인"),
                    //     ),
                    //     OutlinedButton(
                    //       onPressed: () {
                    //         context.go('/manager');
                    //       },
                    //       child: Text("관리자"),
                    //     ),
                    //
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedBackground(ParticleOptions particleOptions) {
    return Container(
      child: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particleOptions),
        child: Container(),
      ),
    );
  }
}

// particle 옵션, color만 받아서 추가
class ParticleOptionsData {
  final Color baseColor;

  const ParticleOptionsData({required this.baseColor});

  ParticleOptions get particleOptions => ParticleOptions(
        baseColor: baseColor,
        spawnOpacity: 0.0,
        opacityChangeRate: 0.25,
        minOpacity: 0.1,
        maxOpacity: 0.4,
        particleCount: 10,
        spawnMaxRadius: 25.0,
        spawnMaxSpeed: 30.0,
        spawnMinSpeed: 10,
        spawnMinRadius: 10.0,
      );
}
