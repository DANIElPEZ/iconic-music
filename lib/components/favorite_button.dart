import 'package:flutter/material.dart';
import 'package:iconicmusic/models/musicModel.dart';
import 'package:iconicmusic/provider/musicProvider.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  Favorite(
      {required this.id,
      required this.title,
      required this.artist,
      required this.photo,
      required this.file_url});
  final int id;
  final String title, photo, file_url, artist;

  @override
  State<StatefulWidget> createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<musicProvider>(builder: (context, music_provider, child) {
      Musicmodel music = Musicmodel(
          id: widget.id,
          title: widget.title,
          artist: widget.artist,
          file_url: widget.file_url,
          image_url: widget.photo);
      return GestureDetector(
          onTap: () {
            if (music_provider.isAdded) {
              music_provider.deleteMyMusic(widget.id);
            } else {
              music_provider.addFavorite(music);
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
              child: Icon(
                  music_provider.isAdded
                      ? Icons.favorite
                      : Icons.favorite_border_rounded,
                  color: Colors.red,
                  size: 30)));
    });
  }
}
