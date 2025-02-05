import 'package:flutter/material.dart';
import 'package:iconicmusic/colors_and_shapes/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/colors_and_shapes/appBarShape.dart';
import 'package:iconicmusic/components/controls.dart';
import 'package:iconicmusic/components/favorite_button.dart';
import 'package:provider/provider.dart';
import 'package:iconicmusic/provider/musicProvider.dart';
import 'package:audio_service/audio_service.dart';

class ReplayPage extends StatelessWidget {
  ReplayPage(
      {required this.id,
      required this.title,
      required this.artist,
      required this.photo,
      required this.file_url,
      required this.audioHandler});
  final int id;
  final String title, photo, file_url, artist;
  final AudioHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    final music_provider = Provider.of<musicProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await music_provider.myMusicIsAdded(id);
    });

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
                            id: id,
                            title: title,
                            artist: artist,
                            file_url: file_url,
                            photo: photo),
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
                              Text(title,
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
                                      MediaQuery.of(context).size.height / 2.6,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child:
                                      Image.network(photo, fit: BoxFit.cover)),
                              Expanded(child: Container()),
                              Controls(
                                  file_url: file_url,
                                  title: title,
                                  artist: artist,
                              audioHandler: audioHandler)
                            ]))))));
  }
}
