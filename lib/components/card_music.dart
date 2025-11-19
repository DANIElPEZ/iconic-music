import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/views/main_views/replay_view.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:audio_service/audio_service.dart';
import 'package:iconicmusic/blocs/music/music_bloc.dart';
import 'package:iconicmusic/blocs/music/music_event.dart';

class Cardmusic extends StatelessWidget {
  Cardmusic(
      {required this.id,
      required this.title,
      required this.artist,
      required this.url_file,
      required this.url_image,
      required this.audioHandler,
      required this.url_lrc,
      this.is_downloaded = 0,
      this.local_image = ''});

  final int id, is_downloaded;
  final String url_image, title, artist, url_file, url_lrc, local_image;
  final AudioHandler audioHandler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async{
          context.read<musicBloc>().add(LoadMusic(
              id: id,
              title: title,
              artist: artist,
              url_file: url_file,
              url_image: url_image,
              url_lrc: url_lrc));
          context.read<musicBloc>().add(LikedMusic());
          context.read<musicBloc>().add(IsDownloadedMusic());
          await Future.delayed(Duration(milliseconds: 500));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReplayPage(audioHandler: audioHandler)));
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
                      child: is_downloaded == 1
                          ? Image.file(File(local_image), fit: BoxFit.cover)
                          : Image.network(url_image, fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/icon.png',
                                  fit: BoxFit.cover);
                            })),
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
                ]))));
  }
}
