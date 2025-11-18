import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconicmusic/blocs/music/music_event.dart';
import 'package:iconicmusic/blocs/music/music_bloc.dart';

class Download extends StatelessWidget {
  Download(
      {required this.id,
      required this.photo,
      required this.file_url,
      required this.url_lrc});

  final int id;
  final String photo, file_url, url_lrc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
            context.read<musicBloc>().add(DownloadMusic());
        },
        child: Icon(Icons.download,
            color: Colors.white, size: 30));
  }
}
