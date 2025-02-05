import 'package:flutter/material.dart';
import 'package:iconicmusic/colors_and_shapes/colors.dart';
import 'package:iconicmusic/colors_and_shapes/appBarShape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/colors_and_shapes/navColor.dart';
import 'package:iconicmusic/services/audio_handler.dart';
import 'package:iconicmusic/views/music.dart';
import 'package:iconicmusic/views/favorite.dart';
import 'package:audio_service/audio_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.audioHandler});
  final AudioHandler audioHandler;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Stack(children: [
              Positioned.fill(child: Container(color: colorsPalette[1])),
              Positioned.fill(
                  child: CustomPaint(
                painter: customShape(bgColor: colorsPalette[0]),
              )),
              AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: const Icon(
                    Icons.headphones,
                    color: Colors.white,
                  ),
                  title: Text('Iconic Music',
                      style: GoogleFonts.rubikVinyl(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700)),
                  actions: [
                    IconButton(
                      onPressed: () {
                        showDialog(context: context, builder: (context)=>AlertDialog(
                          title: Text('Iconic Music',
                          style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900
                            )
                          ),
                          icon: Image.asset('logo/icon.png', width: 50, height: 50),
                          content: Text('iconic music is an application to listen to master music, which offers free and ad-free music.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            )),
                          backgroundColor: colorsPalette[1],
                        ));
                      },
                      icon: const Icon(Icons.info, color: Colors.white),
                    ),
                    SizedBox(width: 10)
                  ])
            ])),
        bottomNavigationBar: Container(
            height: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: CustomPaint(
                painter: customNavShape(),
                child: NavigationBar(
                    onDestinationSelected: (int index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    backgroundColor: Colors.transparent,
                    selectedIndex: currentIndex,
                    indicatorColor: colorsPalette[3],
                    destinations: const [
                      NavigationDestination(
                          icon: Icon(Icons.home, color: Colors.white),
                          label: 'Home'),
                      NavigationDestination(
                          icon: Icon(Icons.favorite, color: Colors.white),
                          label: 'Favorite')
                    ]))),
        body: [Music(audioHandler: widget.audioHandler),Favorite(audioHandler: widget.audioHandler)][currentIndex]);
  }
}
