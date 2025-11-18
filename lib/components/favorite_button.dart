import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconicmusic/blocs/music/music_event.dart';
import 'package:iconicmusic/blocs/music/music_bloc.dart';
import 'package:iconicmusic/blocs/music/music_state.dart';

class Favorite extends StatefulWidget {
  Favorite(
      {required this.id,
      required this.title,
      required this.artist,
      required this.photo,
      required this.file_url,
      required this.url_lrc});

  final int id;
  final String title, photo, file_url, artist, url_lrc;

  @override
  State<StatefulWidget> createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<musicBloc, musicState>(
        builder: (context, state) {
          return GestureDetector(
          onTap: () {
            if (!state.isLiked) {
              context.read<musicBloc>().add(AddFavorite());
            } else {
              context.read<musicBloc>().add(DeleteFavorite());
            }
          },
          onTapDown: (_) {
            setState(() {
              scale = 0.6;
            });
          },
          onTapUp: (_) {
            setState(() {
              scale = 1.0;
            });
          },
          onTapCancel: () {
            setState(() {
              scale = 1.0;
            });
          },
          child: AnimatedScale(
              scale: scale,
              duration: Duration(milliseconds: 80),
              curve: Curves.bounceInOut,
              child: Icon(state.isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                  color: Colors.white, size: 30)));}
    );
  }
}
