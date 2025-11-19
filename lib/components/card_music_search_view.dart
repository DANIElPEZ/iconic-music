import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/views/secondary_views/replay_search_view.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:audio_service/audio_service.dart';

class CardMusicSearchView extends StatelessWidget {
  CardMusicSearchView(
      {required this.id,
      required this.title,
      required this.url_file,
      required this.url_image,
      required this.audioHandler});

  final String url_image, title, url_file, id;
  final AudioHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReplaySearchView(
                      audioHandler: audioHandler,
                      id: id,
                      title: title,
                      image: url_image,
                      file_url: url_file)));
        },
        child: Card(
            elevation: 10,
            color: colorsPalette[2],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Container(
                margin: const EdgeInsets.only(
                    left: 15, right: 45, top: 12, bottom: 12),
                child: Row(children: [
                  Container(
                      width: 70,
                      height: 70,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: Image.network(url_image, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/icon.png',
                            fit: BoxFit.cover);
                      })),
                  Expanded(child: Container()),
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
                  Expanded(child: Container())
                ]))));
  }
}
