import 'package:flutter/material.dart';
import 'package:ggomal/widgets/navbar_home.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: NavBarHome(),
          body: Stack(
            children: [Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 200, 20, 0),
                    child: InkWell(
                      onTap: () {
                        player.play(AssetSource('images/home/audio/tv.mp3'));
                      },
                      child: Image.asset('assets/images/home/tv.png'),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [Padding(
                      padding: EdgeInsets.fromLTRB(0, 168, 0, 0),
                      child: InkWell(
                        onTap: () {
                          player.play(AssetSource('images/home/audio/sofa.mp3'));
                        },
                        child: Image.asset('assets/images/home/sofa.png'),
                      ),
                    ),InkWell(
                      onTap: () {
                        player.play(AssetSource('images/home/audio/table.mp3'));
                      },
                      child: Image.asset('assets/images/home/table.png'),
                    ),],
                  )
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: InkWell(
                          onTap: () {
                            player.play(AssetSource('images/home/audio/window.mp3'));
                          },
                          child: SizedBox(
                            width: 250,
                            child: Image.asset('assets/images/home/window.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 100, 0, 0),
                        child: InkWell(
                          onTap: () {
                            player.play(AssetSource('images/home/audio/chair.mp3'));
                          },
                          child: Image.asset('assets/images/home/chair.png'),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
              Positioned(
                top: 20,
                left: 160,
                child: InkWell(
                  onTap: () {
                    player.play(AssetSource('images/home/audio/photo.mp3'));
                  },
                  child: SizedBox(
                    width: 150,
                    child: Image.asset('assets/images/home/photo.png'),
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                right : 160,
                child: InkWell(
                  onTap: () {
                    player.play(AssetSource('images/home/audio/person.mp3'));
                  },
                  child: SizedBox(
                    width: 220,
                    child: Image.asset('assets/images/home/girl.png'),
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                left : 600,
                child: InkWell(
                  onTap: () {
                    player.play(AssetSource('images/home/audio/pot.mp3'));
                  },
                  child: SizedBox(
                    width: 100,
                    child: Image.asset('assets/images/home/pot.png'),
                  ),
                ),
              ),
            ]
          ),
        ));
  }
}
