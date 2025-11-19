import 'package:flutter/material.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/theme/shapes/app_bar_shape.dart';
import 'package:iconicmusic/components/controls.dart';
import 'package:audio_service/audio_service.dart';

class ReplaySearchView extends StatelessWidget {
  ReplaySearchView(
      {required this.audioHandler,
      required this.id,
      required this.title,
      required this.image,
      required this.file_url});

  final AudioHandler audioHandler;
  final String title, image, file_url, id;

  List<Map<String, dynamic>> lyrics = [];

  Duration position = Duration.zero;

  @override
  Widget build(BuildContext context) {
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
                          fontWeight: FontWeight.w700)))
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
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 12),
                        child: Column(children: [
                          Text(title,
                              style: GoogleFonts.schoolbell(
                                  color:
                                      const Color.fromARGB(255, 233, 233, 233),
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
                              child: Image.network(image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/icon.png',
                                    fit: BoxFit.cover);
                              })),
                          SizedBox(height: 15),
                          Text('Lyrics not available.',
                              style: GoogleFonts.dekko(
                                fontSize: 23,
                                color: Colors.white
                              ))
                        ]))))),
        bottomNavigationBar: Container(
          height: 120,
          color: colorsPalette[1],
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 48, vertical: 15),
            child: Controls(
                file_url: file_url,
                title: title,
                artist: '',
                image_url: image,
                audioHandler: audioHandler),
          ),
        ));
  }
}
