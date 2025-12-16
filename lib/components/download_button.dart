import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconicmusic/blocs/music/music_state.dart';
import 'package:iconicmusic/blocs/music/music_bloc.dart';
import 'package:iconicmusic/blocs/music/music_event.dart';

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
    return BlocBuilder<musicBloc, musicState>(
      builder: (context, state) {
        if (state.downloading) {
          return SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              value: state.downloadProgress > 0
                  ? state.downloadProgress
                  : null,
              strokeWidth: 3,
              color: Colors.white,
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            context.read<musicBloc>().add(DownloadMusic());
          },
          child: Icon(Icons.download, color: Colors.white, size: 30),
        );
      }
    );
  }
}
