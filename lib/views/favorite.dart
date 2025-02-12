import 'package:flutter/material.dart';
import 'package:iconicmusic/colors_and_shapes/colors.dart';
import 'package:provider/provider.dart';
import 'package:iconicmusic/components/cardMusic.dart';
import 'package:iconicmusic/provider/musicProvider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audio_service/audio_service.dart';
import 'package:iconicmusic/services/audio_handler_playlist.dart';

class Favorite extends StatefulWidget {
  Favorite({required this.audioHandler});
  final AudioHandler audioHandler;

  @override
  State<StatefulWidget> createState() => _Favoritemusic();
}

class _Favoritemusic extends State<Favorite> {
  musicProvider? music_provider;

  @override
  void initState() {
    music_provider=Provider.of<musicProvider>(context, listen: false);
    super.initState();
  }

  Future<void> playPlaylist() async{
    try {
      Future.delayed(Duration(microseconds: 900));
      final playListMusics = music_provider?.myMusics.map((music)=>(music.file_url)).toList();
      final playlist_handler=AudioServiceHandler();
      await playlist_handler.loadPlaylist(playListMusics!);
      await playlist_handler.startPlayback();
    }catch(e){
      print('error $e');
    }
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
                          audioHandler: widget.audioHandler);
                        }),
                    Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                            onPressed: (){
                              showDialog(context: context, builder: (context)=>AlertDialog(
                                icon: Image.asset('logo/icon.png', width: 50, height: 50),
                                content: Text('Under development.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.playfairDisplay(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600
                                    )),
                                backgroundColor: colorsPalette[1],
                              ));
                              //playPlaylist();
                            },
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