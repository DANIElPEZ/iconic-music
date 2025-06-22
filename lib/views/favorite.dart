import 'package:flutter/material.dart';
import 'package:iconicmusic/colors_and_shapes/colors.dart';
import 'package:iconicmusic/models/musicModel.dart';
import 'package:provider/provider.dart';
import 'package:iconicmusic/components/cardMusic.dart';
import 'package:iconicmusic/provider/musicProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audio_service/audio_service.dart';
import 'package:iconicmusic/services/audio_handler.dart';

class Favorite extends StatefulWidget {
  Favorite({required this.audioHandler});
  final AudioHandler audioHandler;

  @override
  State<StatefulWidget> createState() => _Favoritemusic();
}

class _Favoritemusic extends State<Favorite> {

  Future<void> playPlaylist() async{
    try {
      final music_provider=Provider.of<musicProvider>(context, listen: false);
      Future.delayed(Duration(microseconds: 900));
      List<MediaItem> playListMusics = music_provider!.myMusics.map((music)=>convertToMediaItem(music)).toList();
      await (widget.audioHandler as audioHandler).setPlaylist(playListMusics);
    }catch(e){
      print('error $e');
    }
  }

  MediaItem convertToMediaItem(Musicmodel music){
    return MediaItem(id: music.file_url, title: music.title,
    artUri: Uri.parse(music.image_url));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            color: colorsPalette[1],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Consumer<musicProvider>(builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(
                    child:
                        SpinKitThreeBounce(color: colorsPalette[2], size: 33));
              } else if (provider.getConnection) {
                if (provider.myMusics.isNotEmpty) {
                  final musics = provider.myMusics;
                  return Stack(children: [
                    ListView.builder(
                        itemCount: musics.length,
                        itemBuilder: (context, index) {
                          return Cardmusic(
                              id: musics[index].id,
                              title: musics[index].title,
                              artist: musics[index].artist,
                              url: musics[index].file_url,
                              image: musics[index].image_url,
                          url_lrc: musics[index].url_lrc,
                          audioHandler: widget.audioHandler);
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
              } else {
                return Center(
                    child: Text('Please, check the internet connection',
                        style: GoogleFonts.spaceGrotesk(
                            color: Colors.white, fontSize: 20)));
              }
            })));
  }
}