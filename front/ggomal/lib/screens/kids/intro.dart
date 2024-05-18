import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'main.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  final AudioPlayer player = AudioPlayer(); // AudioPlayer 인스턴스 추가
  int _currentPage = 0;

  final List<String> _descriptions = [
    '첫 번째 설명입니다.',
    '두 번째 설명입니다.',
    '세 번째 설명입니다.',
    '세 번째 설명입니다.',
  ];

  final List<String> _images = [
    'assets/images/intro/intro_new1.png',
    'assets/images/intro/intro_new2.png',
    'assets/images/intro/intro_new3.png',
    'assets/images/intro/intro_new4.png'
  ];

  final List<String> _audioFiles = [
    'audio/intro/intro_1.mp3',
    'audio/intro/intro_2.mp3',
    'audio/intro/intro_new_3.mp3',
    'audio/intro/intro_new_4.mp3',
  ];

  @override
  void initState() {
    super.initState();
    _playAudio(_currentPage); // 첫 번째 페이지의 오디오 재생
  }

  void _playAudio(int index) async {
    try {
      await player.stop(); // 이전 오디오 중지
      await player.play(AssetSource(_audioFiles[index])); // 새 오디오 재생
      print("Playing audio: ${_audioFiles[index]}"); // 디버깅 메시지
    } catch (e) {
      print("Error playing audio: $e"); // 에러 메시지 출력
    }
  }

  void _nextPage() {
    if (_currentPage < _descriptions.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/main');
    }
  }

  @override
  void dispose() {
    player.dispose(); // 오디오 플레이어 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.8;
    double height = screenSize.height * 0.7;

    return Scaffold(
      body: Stack(
        children: [
          MainScreen(), // 메인 스크린을 백그라운드에 표시합니다.
          PageView.builder(
            controller: _pageController,
            itemCount: _descriptions.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              _playAudio(index); // 페이지 변경 시 오디오 재생
            },
            itemBuilder: (context, index) {
              return Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Image.asset(
                    _images[index],
                    fit: BoxFit.cover,
                    width: width,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: screenSize.height * 0.4,
            left: screenSize.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage < _descriptions.length - 1)
                  GestureDetector(
                    onTap: () {
                      _nextPage();
                    },
                    child: Image.asset(
                      'assets/images/intro/next_button.png',
                      height: 150,
                    ),
                  ),
                if (_currentPage == _descriptions.length - 1)
                  GestureDetector(
                    onTap: () {
                      context.go('/kids');
                    },
                    child: Image.asset(
                      'assets/images/intro/next_button.png',
                      height: 150,
                    ),
                  )
              ],
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.1,
            left: screenSize.width * 0.9,
            child: GestureDetector(
              onTap: () {
                context.go('/kids');
              },
              child: Text(
                "스킵하기",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Maplestory',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
