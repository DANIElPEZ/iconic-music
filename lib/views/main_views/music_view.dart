import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconicmusic/components/card_music.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audio_service/audio_service.dart';
import 'package:iconicmusic/blocs/music/music_bloc.dart';
import 'package:iconicmusic/blocs/music/music_state.dart';

class Music extends StatefulWidget {
  Music({required this.audioHandler});

  final AudioHandler audioHandler;

  @override
  State<StatefulWidget> createState() => _Music();
}

class _Music extends State<Music> with SingleTickerProviderStateMixin {
  List<dynamic> filteredMusicList = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadControllers();
  }

  Future<void> loadControllers() async {
    final myMusics = context.read<musicBloc>().state.musics;
    await Future.delayed(Duration(microseconds: 800));
    filteredMusicList = myMusics;
    searchController.addListener(filterMusicList);
  }

  void filterMusicList() {
    final myMusics = context.read<musicBloc>().state.musics;
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredMusicList = myMusics.where((music) {
        final title = music['title'].toLowerCase();
        final artist = music['artist'].toLowerCase();
        return title.contains(query) || artist.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> findMusic(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                icon: Container(
                    width: 70,
                    height: 70,
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle),
                    child:
                        Image.asset('assets/icon.png', width: 60, height: 60)),
                title: Text('Search your music',
                    style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                content: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: Colors.white,
                          selectionColor: Colors.white.withAlpha(150),
                          selectionHandleColor: Colors.white
                        ),
                      ),
                      child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: 'AC/DC, Qeen, ...',
                              hintStyle: GoogleFonts.spaceGrotesk(
                                  color: Colors.white.withAlpha(200),
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.1)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.4))),
                          style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                    )),
                backgroundColor: colorsPalette[1],
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close',
                          style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorsPalette[4]))
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: colorsPalette[1],
        child: BlocBuilder<musicBloc, musicState>(builder: (context, state) {
          if (!state.loading &&
              filteredMusicList.isEmpty &&
              state.musics.isNotEmpty) {
            filteredMusicList = state.musics;
          }
          if (state.loading) {
            return Center(
                child: SpinKitThreeBounce(color: colorsPalette[2], size: 33));
          } else if (state.musics.isNotEmpty) {
            return Stack(children: [
              searchController.text.isEmpty
                  ? ListView.builder(
                      itemCount: state.musics.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Cardmusic(
                            id: state.musics[index]['id'],
                            title: state.musics[index]['title'],
                            artist: state.musics[index]['artist'],
                            url_file: state.musics[index]['file_url'],
                            url_image: state.musics[index]['image_url'],
                            url_lrc: state.musics[index]['url_lrc'],
                            audioHandler: widget.audioHandler);
                      })
                  : ListView.builder(
                      itemCount: filteredMusicList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Cardmusic(
                            id: filteredMusicList[index]['id'],
                            title: filteredMusicList[index]['title'],
                            artist: filteredMusicList[index]['artist'],
                            url_file: filteredMusicList[index]['file_url'],
                            url_image: filteredMusicList[index]['image_url'],
                            url_lrc: filteredMusicList[index]['url_lrc'],
                            audioHandler: widget.audioHandler);
                      }),
              Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                      onPressed: () {
                        findMusic(context);
                      },
                      backgroundColor: colorsPalette[4],
                      child: Icon(Icons.search, color: Colors.white, size: 32)))
            ]);
          } else {
            return Center(
                child: Text('Please, check the internet connection',
                    style: GoogleFonts.spaceGrotesk(
                        color: Colors.white, fontSize: 20)));
          }
        }));
  }
}
