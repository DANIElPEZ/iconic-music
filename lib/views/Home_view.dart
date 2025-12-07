import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconicmusic/theme/colors.dart';
import 'package:iconicmusic/theme/shapes/app_bar_shape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/theme/shapes/bottom_nav_shape.dart';
import 'package:iconicmusic/views/main_views/music_view.dart';
import 'package:iconicmusic/views/main_views/favorite_view.dart';
import 'package:iconicmusic/views/secondary_views/search_view.dart';
import 'package:iconicmusic/views/secondary_views/policies.dart';
import 'package:iconicmusic/utils/ad_utils.dart';
import 'package:iconicmusic/services/audio_service_initializer.dart';
import 'package:iconicmusic/blocs/music/music_bloc.dart';
import 'package:iconicmusic/blocs/music/music_event.dart';
import 'package:new_version_plus/new_version_plus.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int currentIndex = 1;
  final ad_helper = adUtils();
  AudioHandler? audioHandler;
  late PageController pageController;

  void loadAudioHandler() async {
    audioHandler = await initAudioHandler();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    context.read<musicBloc>().add(LoadMusics());
    context.read<musicBloc>().add(LoadFavoriteMusics());
    pageController = PageController(initialPage: currentIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAudioHandler();
      checkForUpdate(context);
    });
  }

  @override
  void dispose() {
    ad_helper.dispose();
    super.dispose();
  }

  Future<void> checkForUpdate(BuildContext context) async {
    final newVersion = NewVersionPlus(androidId: 'com.dnv.dev.iconicmusic');
    final status = await newVersion.getVersionStatus();
    if (status != null && status.canUpdate) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (context) =>
            AlertDialog(
              backgroundColor: colorsPalette[1],
              title: Text(
                'New version available',
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async{
                    Navigator.pop(context);
                    await newVersion.launchAppStore('https://play.google.com/store/apps/details?id=com.dnv.dev.iconicmusic');
                  },
                  child: Text(
                    'Update',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor:colorsPalette[4]
                  )
                )
              ]
            )
      );
    }
  }

  Future<void> info(BuildContext context)async{
    return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
              title: Text('Iconic Music',
                  style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900)),
              icon:  Container(
                  width: 70,
                  height: 70,
                  clipBehavior: Clip.antiAlias,
                  decoration:
                  BoxDecoration(shape: BoxShape.circle),
                  child:
                  Image.asset('assets/icon.png', width: 60, height: 60)),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PoliciesView()));
                    },
                    child: Text('Policies',
                        style:
                        GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        colorsPalette[4])),
                SizedBox(width: 40),
                ElevatedButton(
                    onPressed: () {
                      if (ad_helper.isAdLoaded &&
                          !ad_helper.initialAdShown) {
                        ad_helper.showRewardedAd(context);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Close',
                        style:
                        GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                        colorsPalette[4]))
              ],
              content: Text(
                  'iconic music is an application to listen to master music, eg: AC/DC, Qeen, etc.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              backgroundColor: colorsPalette[1]
          ));
  }

  @override
  Widget build(BuildContext context) {
    if (audioHandler == null) {
      return Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Stack(children: [
                Positioned.fill(child: Container(color: colorsPalette[1])),
                Positioned.fill(
                    child: CustomPaint(
                  painter: customShape(bgColor: colorsPalette[0]),
                )),
                AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: const Icon(
                      Icons.headphones,
                      color: Colors.white,
                    ),
                    title: Text('Iconic Music',
                        style: GoogleFonts.rubikVinyl(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700)),
                    actions: [
                      IconButton(
                          onPressed: () {
                            context.read<musicBloc>().add(LoadMusics());
                            context.read<musicBloc>().add(LoadFavoriteMusics());
                          },
                          icon: Icon(Icons.update, color: Colors.white)),
                      IconButton(
                        onPressed: (){
                          info(context);
                        },
                        icon: const Icon(Icons.info, color: Colors.white),
                      ),
                      SizedBox(width: 10)
                    ])
              ])),
          bottomNavigationBar: Container(
              height: 80,
              child: CustomPaint(
                  painter: customNavShape(bgColor: colorsPalette[1], colors: [
                    colorsPalette[0],
                    colorsPalette[3],
                    colorsPalette[1],
                    colorsPalette[3]
                  ]),
                  child: NavigationBar(
                      backgroundColor: Colors.transparent,
                      selectedIndex: currentIndex,
                      indicatorColor: colorsPalette[3],
                      destinations: const [
                        NavigationDestination(
                            icon: Icon(Icons.home, color: Colors.white),
                            label: 'Home'),
                        NavigationDestination(
                            icon: Icon(Icons.favorite, color: Colors.white),
                            label: 'Favorite')
                      ]))),
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: colorsPalette[1],
              child: Center(child: SpinKitThreeBounce(color: colorsPalette[2], size: 33))));
    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Stack(children: [
              Positioned.fill(child: Container(color: colorsPalette[1])),
              Positioned.fill(
                  child: CustomPaint(
                painter: customShape(bgColor: colorsPalette[0]),
              )),
              AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: const Icon(
                    Icons.headphones,
                    color: Colors.white,
                  ),
                  title: Text('Iconic Music',
                      style: GoogleFonts.rubikVinyl(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700)),
                  actions: [
                    IconButton(
                        onPressed: () {
                          context.read<musicBloc>().add(LoadMusics());
                          context.read<musicBloc>().add(LoadFavoriteMusics());
                        },
                        icon: Icon(Icons.update, color: Colors.white)),
                    IconButton(
                      onPressed: (){
                        info(context);
                      },
                      icon: const Icon(Icons.info, color: Colors.white),
                    ),
                    SizedBox(width: 10)
                  ])
            ])),
        bottomNavigationBar: Container(
            height: 80,
            child: CustomPaint(
                painter: customNavShape(bgColor: colorsPalette[1], colors: [
                  colorsPalette[0],
                  colorsPalette[3],
                  colorsPalette[1],
                  colorsPalette[3]
                ]),
                child: NavigationBar(
                    animationDuration: Duration(milliseconds: 400),
                    onDestinationSelected: (int index) {
                      setState(() =>currentIndex = index);
                      pageController.animateToPage(index,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut);
                    },
                    backgroundColor: Colors.transparent,
                    selectedIndex: currentIndex,
                    indicatorColor: colorsPalette[3],
                    destinations: const [
                      NavigationDestination(
                          icon: Icon(Icons.search, color: Colors.white),
                          label: 'Search'),
                      NavigationDestination(
                          icon: Icon(Icons.home, color: Colors.white),
                          label: 'Home'),
                      NavigationDestination(
                          icon: Icon(Icons.favorite, color: Colors.white),
                          label: 'Favorite')
                    ]))),
        body: PageView(
          controller: pageController,
          onPageChanged: (int index) {
            setState(() =>  currentIndex = index);
          },
            children: [
              Seacrh(audioHandler: audioHandler!),
              Music(audioHandler: audioHandler!),
              Favorite(audioHandler: audioHandler!)
            ],
          ));
  }
}
