import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconicmusic/provider/musicProvider.dart';
import 'package:iconicmusic/components/cardMusic.dart';
import 'package:iconicmusic/colors_and_shapes/colors.dart';
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

  @override
  void initState() {
    super.initState();

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
                return ListView.builder(
                    itemCount: musics.length,
                    itemBuilder: (context, index) {
                      return Cardmusic(
                          id: musics[index].id,
                          title: musics[index].title,
                          artist: musics[index].artist,
                          url: musics[index].file_url,
                          image: musics[index].image_url,
                      audioHandler: widget.audioHandler);
                    });
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
