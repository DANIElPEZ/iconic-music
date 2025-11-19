import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/theme/shapes/app_bar_shape.dart';
import 'package:iconicmusic/components/controls.dart';
import 'package:iconicmusic/components/favorite_button.dart';
import 'package:iconicmusic/components/download_button.dart';
import 'package:iconicmusic/utils/convert_lrc.dart';
import 'package:audio_service/audio_service.dart';
import 'dart:async';
import 'package:iconicmusic/blocs/music/music_bloc.dart';
import 'package:iconicmusic/blocs/music/music_state.dart';
import 'package:iconicmusic/utils/ad_utils.dart';

class ReplayPage extends StatefulWidget {
  ReplayPage({required this.audioHandler});

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
  double containerHeight = 0;
  final double lineHeightEstimate = 35.0;
  StreamSubscription? playbackSub;
  final ad_helper=adUtils();

  @override
  void initState() {
    super.initState();
    initializeLyrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final showAd = context.read<musicBloc>().state.showad;

      ad_helper.loadRewardedAd(onReady: () {
        if (ad_helper.isAdLoaded && !ad_helper.initialAdShown && showAd == 2) {
          ad_helper.showRewardedAd(context);
        }
      });
    });
  }

  Future<void> initializeLyrics() async {
    playbackSub = widget.audioHandler.playbackState.listen((state) {
      if (mounted) {
        setState(() {
          position = state.position;
          isPlaying = state.playing;
        });
      }
    });

    final state = context.read<musicBloc>().state;

    try {
      if (state.isDownloaded) {
        lyrics = await parseLocalLRC(state.url_lrc);
      } else {
        lyrics = await fetchAndParseLRC(state.url_lrc);
      }
      startLyrics();
    } catch (e) {
      print('error $e');
    }
  }

  void startLyrics() {
    timer?.cancel();
    timer = Timer.periodic(Duration(microseconds: 100), (timer) {
      if (isPlaying) {
        double currentPosition = position.inMilliseconds / 1000;
        int newIndex =
            lyrics.indexWhere((line) => currentPosition < line['time']);
        if (newIndex > 0) newIndex--;
        if (newIndex != currentLyricsIndex && newIndex != -1) {
          setState(() {
            currentLyricsIndex = newIndex;
          });

          if (containerHeight > 0) {
            final maxScrollExtent =
                (lyrics.length * lineHeightEstimate) - containerHeight;
            double targetOffset = (newIndex * lineHeightEstimate) -
                (containerHeight / 2 - lineHeightEstimate / 2);
            targetOffset = targetOffset.clamp(0, maxScrollExtent);
            scrollController.animateTo(targetOffset,
                duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    playbackSub?.cancel();
    timer?.cancel();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<musicBloc, musicState>(builder: (context, state) {
      return Scaffold(
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
                      },
                      color: Colors.white,
                    ),
                    title: Text('Iconic Music',
                        style: GoogleFonts.rubikVinyl(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700)),
                    actions: [
                      state.isDownloaded
                          ? SizedBox()
                          : Download(
                              id: state.id,
                              file_url: state.url_file,
                              photo: state.url_image,
                              url_lrc: state.url_lrc),
                      SizedBox(width: 15),
                      Favorite(
                        id: state.id,
                        file_url: state.url_file,
                        photo: state.url_image,
                        url_lrc: state.url_lrc,
                        title: state.title,
                        artist: state.artist,
                      ),
                      SizedBox(width: 15)
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
                            Text(state.title,
                                style: GoogleFonts.schoolbell(
                                    color: const Color.fromARGB(
                                        255, 233, 233, 233),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                            SizedBox(height: 6),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 230,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: state.isDownloaded
                                    ? Image.file(File(state.url_image),
                                        fit: BoxFit.cover)
                                    : Image.network(state.url_image,
                                        fit: BoxFit.cover, errorBuilder:
                                            (context, error, stackTrace) {
                                        return Image.asset('assets/icon.png',
                                            fit: BoxFit.cover);
                                      })),
                            SizedBox(height: 15),
                            Flexible(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  // Actualizar containerHeight después de que el framework haya construido los widgets
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted &&
                                        containerHeight !=
                                            constraints.maxHeight) {
                                      setState(() {
                                        containerHeight = constraints.maxHeight;
                                      });
                                    }
                                  });
                                  return ListView.builder(
                                    controller: scrollController,
                                    itemCount: lyrics.length,
                                    itemBuilder: (context, index) {
                                      bool isCurrent =
                                          index == currentLyricsIndex;
                                      return AnimatedDefaultTextStyle(
                                        child: Container(
                                          height: lineHeightEstimate,
                                          // Altura fija para cada línea
                                          alignment: Alignment.center,
                                          child: Text(
                                            lyrics[index]['text'],
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        style: GoogleFonts.dekko(
                                          fontSize: 23,
                                          color: isCurrent
                                              ? Colors.white
                                              : Colors.grey[700],
                                        ),
                                        duration: Duration(milliseconds: 300),
                                      );
                                    },
                                  );
                                },
                              ),
                            )
                          ]))))),
          bottomNavigationBar: Container(
            height: 120,
            color: colorsPalette[1],
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 15),
              child: Controls(
                  file_url: state.url_file,
                  title: state.title,
                  artist: state.artist,
                  image_url: state.url_image,
                  audioHandler: widget.audioHandler),
            ),
          ));
    });
  }
}
