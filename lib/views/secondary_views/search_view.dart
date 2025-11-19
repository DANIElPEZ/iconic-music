import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/blocs/search/search_bloc.dart';
import 'package:iconicmusic/blocs/search/search_state.dart';
import 'package:iconicmusic/blocs/search/search_event.dart';
import 'package:iconicmusic/components/card_music_search_view.dart';

class Seacrh extends StatefulWidget{
  Seacrh({required this.audioHandler});
  final AudioHandler audioHandler;
  @override
  State<Seacrh> createState() => _SeacrhState();
}

class _SeacrhState extends State<Seacrh> {
  final TextEditingController searchController=TextEditingController();

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
              context.read<SearchBloc>().add(setQuery(searchController.text.trim()));
              context.read<SearchBloc>().add(loadSearch());
              Navigator.of(context).pop();
            }, child: Text('Search',
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
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: colorsPalette[1],
        child :BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
          if (state.loading) {
            return Center(
                child:
                SpinKitThreeBounce(color: colorsPalette[2], size: 33));
          }else if(state.data!.isNotEmpty){
            return Stack( children: [
                            ListView.builder(
                  itemCount: state.data!.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index){
                    return CardMusicSearchView(
                        id: state.data![index]['id'],
                        title: state.data![index]['title'],
                        url_file: state.data![index]['file_url'],
                        url_image: state.data![index]['image'],
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
          }else{
            return Stack(
              children: [
                Center(
                    child: Text(
                        'Search, your music',
                        style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 20)
                    )),
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
              ],
            );
          }
        })
    );
  }
}