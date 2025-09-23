import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/views/replay.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:audio_service/audio_service.dart';

class Cardmusic extends StatelessWidget {
  Cardmusic(
      {required this.id,
      required this.title,
      required this.artist,
      required this.url,
      required this.image,
      required this.audioHandler,
      required this.url_lrc});

  int id;
  String image, title, artist, url, url_lrc;
  final AudioHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReplayPage(
                    id: id,
                    url_lrc: url_lrc,
                    title: title,
                    artist: artist,
                    photo: image,
                    file_url: url,
                    audioHandler: audioHandler)));
      },
      child: Card(
          elevation: 10,
          color: colorsPalette[2],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Container(
            margin:
                const EdgeInsets.only(left: 15, right: 45, top: 12, bottom: 12),
            child: Row(children: [
              Container(
                  width: 70,
                  height: 70,
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: Image.network(image, fit: BoxFit.cover)),
              Expanded(child: Container()),
              Column(children: [
                Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    child: Text(title,
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.caveat(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w900))),
                Text(artist,
                    style: GoogleFonts.caveat(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800))
              ]),
              Expanded(child: Container())
            ]),
          )),
    );
  }
}
