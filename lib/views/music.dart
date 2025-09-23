import 'package:flutter/material.dart';
import 'package:iconicmusic/models/musicModel.dart';
import 'package:provider/provider.dart';
import 'package:iconicmusic/provider/musicProvider.dart';
import 'package:iconicmusic/components/cardMusic.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audio_service/audio_service.dart';

class Music extends StatefulWidget {
  Music({required this.audioHandler});
  final AudioHandler audioHandler;

  @override
  State<StatefulWidget> createState() => _Music();
}

class _Music extends State<Music> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  List<Musicmodel> filteredMusicList=[];
  final TextEditingController searchController=TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSearchController();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: colorsPalette[4],
      end: colorsPalette[1],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> loadSearchController()async{
    final music=Provider.of<musicProvider>(context, listen: false);
    await music.checkConnection();
    await Future.delayed(Duration(microseconds: 800));
    filteredMusicList=music.musics;
    searchController.addListener(filterMusicList);
  }

  void filterMusicList(){
    final music=Provider.of<musicProvider>(context, listen: false);
    final query=searchController.text.toLowerCase();

    setState(() {
      filteredMusicList=music.musics.where((music){
        final title =music.title.toLowerCase();
        final artist=music.artist.toLowerCase();

        return title.contains(query) || artist.contains(query);
      }).toList();
    });
  }

  @override
  void dispose(){
    searchController.dispose();
    super.dispose();
  }

  Future<void> findMusic(BuildContext context)async{
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (context)=>AlertDialog(icon: Image.asset('assets/icon.png', width: 50, height: 50),
      title: Text('Search your music',
      style: GoogleFonts.playfairDisplay(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600
      )),
      content: Padding(padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'AC/DC, Qeen, ...',
          hintStyle: GoogleFonts.spaceGrotesk(
              color: Colors.white.withAlpha(200),
              fontSize: 19,
              fontWeight: FontWeight.w500
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1.1
            )
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1.4
            )
          )
        ),
        style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500
        ),
        cursorColor: Colors.white
      )),
      backgroundColor: colorsPalette[1],
            actions: [ElevatedButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Close',
                style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                )),
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorsPalette[4]
                ))]
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: colorsPalette[1],
            child: Consumer<musicProvider>(builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(
                    child: AnimatedBuilder(
                        animation: _colorAnimation,
                        builder: (context, child) {
                          return SpinKitDoubleBounce(
                              color: _colorAnimation.value, size: 50.0);
                        }));
              } else if (provider.getConnection && provider.musics.isNotEmpty) {
                final musics = provider.musics;
                return Stack( children: [
                  filteredMusicList.isEmpty?
                  ListView.builder(
                    itemCount: musics.length,
                    itemBuilder: (context, index){
                      return Cardmusic(
                          id: musics[index].id,
                          title: musics[index].title,
                          artist: musics[index].artist,
                          url: musics[index].file_url,
                          image: musics[index].image_url,
                      audioHandler: widget.audioHandler,
                      url_lrc: musics[index].url_lrc);
                    }):
                  ListView.builder(
                      itemCount: filteredMusicList.length,
                      itemBuilder: (context, index) {
                        return Cardmusic(
                            id: filteredMusicList[index].id,
                            title: filteredMusicList[index].title,
                            artist: filteredMusicList[index].artist,
                            url: filteredMusicList[index].file_url,
                            image: filteredMusicList[index].image_url,
                            url_lrc: filteredMusicList[index].url_lrc,
                            audioHandler: widget.audioHandler);
                      }),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                        onPressed: (){
                            findMusic(context);
                          },
                        backgroundColor: colorsPalette[4],
                        child: Icon(Icons.search,
                            color: Colors.white, size: 32)))
                ]);
              } else {
                return Center(
                    child: Text(
                  'Please, check the internet connection',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 20)
                ));
              }
            })));
  }
}
