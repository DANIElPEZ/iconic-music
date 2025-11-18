import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:iconicmusic/components/cardMusic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audio_service/audio_service.dart';
import 'package:iconicmusic/services/audio_handler.dart';
import 'package:iconicmusic/blocs/music/music_bloc.dart';
import 'package:iconicmusic/blocs/music/music_state.dart';

class Favorite extends StatefulWidget {
  Favorite({required this.audioHandler});

  final AudioHandler audioHandler;

  @override
  State<StatefulWidget> createState() => _Favoritemusic();
}

class _Favoritemusic extends State<Favorite> {
  Future<void> playPlaylist() async {
    try {
      final myMusics = context.read<musicBloc>().state.favoriteMusics;
      Future.delayed(Duration(milliseconds: 100));
      if (myMusics.isEmpty) return;
      List<MediaItem> playListMusics =
          myMusics.map((music) => convertToMediaItem(music)).toList();
      await (widget.audioHandler as audioHandler).setPlaylist(playListMusics);
    } catch (e) {
      print('error $e');
    }
  }

  MediaItem convertToMediaItem(Map<String, dynamic> music) {
    return MediaItem(
        id: music['file_url'] ?? '',
        title: music['title'] ?? 'Sin título',
        artUri:
            music['image_url'] != null ? Uri.parse(music['image_url']) : null);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            color: colorsPalette[1],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:
                BlocBuilder<musicBloc, musicState>(builder: (context, state) {
              if (state.loading) {
                return Center(
                    child:
                        SpinKitThreeBounce(color: colorsPalette[2], size: 33));
              } else if (state.favoriteMusics.isNotEmpty) {
                return Stack(children: [
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: state.favoriteMusics.length,
                      itemBuilder: (context, index) {
                        return Cardmusic(
                          id: state.favoriteMusics[index]['id'] ?? '',
                          title: state.favoriteMusics[index]['title'] ?? 'Sin título',
                          artist: state.favoriteMusics[index]['artist'] ?? 'Desconocido',
                          url_file: state.favoriteMusics[index]['url_file'] ?? '',
                          url_image: state.favoriteMusics[index]['url_image'] ?? '',
                          url_lrc: state.favoriteMusics[index]['url_lrc'] ?? '',
                          is_downloaded: state.favoriteMusics[index]['is_downloaded']??0,
                          local_image: state.favoriteMusics[index]['local_image']??'',
                          audioHandler: widget.audioHandler
                        );
                      }),
                  Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                          onPressed: playPlaylist,
                          backgroundColor: colorsPalette[4],
                          child: Icon(Icons.playlist_play,
                              color: Colors.white, size: 32)))
                ]);
              } else {
                return Center(
                    child: Text('No favorite musics yet',
                        style: GoogleFonts.spaceGrotesk(
                            color: Colors.white, fontSize: 20)));
              }
            })));
  }
}
