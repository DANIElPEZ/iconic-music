import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconicmusic/colors_and_shapes/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/colors_and_shapes/appBarShape.dart';
import 'package:iconicmusic/components/controls.dart';
import 'package:iconicmusic/components/favorite_button.dart';
import 'package:iconicmusic/services/audio_handler.dart';
import 'package:iconicmusic/services/convert_lrc.dart';
import 'package:provider/provider.dart';
import 'package:iconicmusic/provider/musicProvider.dart';
import 'package:audio_service/audio_service.dart';
import 'dart:async';

class ReplayPage extends StatefulWidget {
  ReplayPage(
      {required this.id,
      required this.title,
      required this.artist,
      required this.photo,
      required this.file_url,
      required this.audioHandler,
      required this.url_lrc});

  final int id;
  final String title, photo, file_url, artist, url_lrc;
  final AudioHandler audioHandler;

  @override
  State<ReplayPage> createState() => _ReplayPageState();
}

class _ReplayPageState extends State<ReplayPage> {
  List<Map<String, dynamic>> lyrics = [];
  int currentLyricsIndex = -1;
  Timer? timer;
  Duration position = Duration.zero;
  bool isPlaying = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    initializeLyrics();
    super.initState();
  }

  Future<void> initializeLyrics() async {
    widget.audioHandler.playbackState.listen((state) {
      setState(() {
        position = state.position;
        isPlaying = state.playing;
      });
    });
    try {
      lyrics = await fetchAndParseLRC(widget.url_lrc);
      startLyrics();
    } catch (e) {
      print('error $e');
    }
  }

  void startLyrics() {
    timer = Timer.periodic(Duration(microseconds: 350), (timer) {
      if (isPlaying) {
        double currentPosition = position.inMilliseconds / 1000;
        int newIndex =
            lyrics.indexWhere((line) => currentPosition < line['time']);
        if (newIndex > 0) newIndex--;
        if (newIndex != currentLyricsIndex && newIndex != -1) {
          setState(() {
            currentLyricsIndex = newIndex;
          });

          scrollController.animateTo(35.0 * newIndex + 1,
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final music_provider = Provider.of<musicProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await music_provider.myMusicIsAdded(widget.id);
    });

    return WillPopScope(
        onWillPop: () async {
          music_provider.getMyMusics();
          return true;
        },
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Stack(children: [
                  Positioned.fill(child: Container(color: colorsPalette[4])),
                  Positioned.fill(
                      child: CustomPaint(
                    painter: customShape(bgColor: colorsPalette[3]),
                  )),
                  AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                          music_provider.getMyMusics();
                        },
                        color: Colors.white,
                      ),
                      title: Text('Iconic Music',
                          style: GoogleFonts.rubikVinyl(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w700)),
                      actions: [
                        Favorite(
                            id: widget.id,
                            title: widget.title,
                            artist: widget.artist,
                            file_url: widget.file_url,
                            photo: widget.photo,
                            url_lrc: widget.url_lrc),
                        const SizedBox(width: 15)
                      ])
                ])),
            body: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: colorsPalette[4],
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        shadowColor: Colors.black,
                        color: colorsPalette[1],
                        margin:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 13, horizontal: 12),
                            child: Column(children: [
                              Text(widget.title,
                                  style: GoogleFonts.schoolbell(
                                      color: const Color.fromARGB(
                                          255, 233, 233, 233),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center),
                              SizedBox(height: 6),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 2.9,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Image.network(widget.photo,
                                      fit: BoxFit.cover)),
                              SizedBox(height: 15),
                              Flexible(
                                child: ListView.builder(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    itemCount: lyrics.length,
                                    itemBuilder: (context, index) {
                                      bool isCurrent =
                                          index == currentLyricsIndex;
                                      return AnimatedDefaultTextStyle(
                                          child: Text(
                                              textAlign: TextAlign.center,
                                              lyrics[index]['text']),
                                          style: GoogleFonts.dekko(
                                              fontSize: 23,
                                              color: isCurrent
                                                  ? Colors.white
                                                  : Colors.grey[700]),
                                          duration:
                                              Duration(milliseconds: 300));
                                    })
                              )
                            ]))))),
            bottomNavigationBar: Container(
              height: 120,
              color: colorsPalette[1],
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 15),
                child: Controls(
                    file_url: widget.file_url,
                    title: widget.title,
                    artist: widget.artist,
                    image_url: widget.photo,
                    audioHandler: widget.audioHandler),
              ),
            )));
  }
}
