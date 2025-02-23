import 'package:flutter/material.dart';
import 'package:iconicmusic/colors_and_shapes/colors.dart';
import 'package:iconicmusic/colors_and_shapes/appBarShape.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconicmusic/colors_and_shapes/navColor.dart';
import 'package:iconicmusic/views/music.dart';
import 'package:iconicmusic/views/favorite.dart';
import 'package:audio_service/audio_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconicmusic/provider/musicProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.audioHandler});
  final AudioHandler audioHandler;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int currentIndex = 0;
  RewardedAd? rewardedAd;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad){
            ad.fullScreenContentCallback=FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad){
                setState(() {
                  ad.dispose();
                  rewardedAd=null;
                });
                loadRewardedAd();
              }
            );

            setState(() {
              rewardedAd=ad;
            });
          },
          onAdFailedToLoad: (e){
            print('Failed to load a rewarded ad: $e');
          })
    );
  }

  @override
  void initState() {
    super.initState();
    loadRewardedAd();
  }

  @override
  void dispose() {
    rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    IconButton(onPressed: (){
                      final music=Provider.of<musicProvider>(context, listen: false);
                      music.checkConnection();
                      Future.delayed(Duration(microseconds: 900));
                      music.fetchMusics();
                      music.getMyMusics();
                    }, icon: Icon(Icons.update, color: Colors.white)),
                    IconButton(
                      onPressed: () {
                        showDialog(context: context,
                            barrierDismissible: false,
                            builder: (context)=>AlertDialog(
                          title: Text(
                              'Iconic Music',
                              style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900
                              )
                          ),
                          icon: Image.asset('assets/icon.png', width: 50, height: 50),
                          actions: [ElevatedButton(onPressed: (){
                            if (rewardedAd != null) {
                              rewardedAd!.show(
                                onUserEarnedReward: (_, reward) {
                                  print('User earned a reward of ${reward.amount}');
                                },
                              );
                            }
                            Navigator.of(context).pop();
                          }, child: Text('Close',
                          style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                          )),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorsPalette[4]
                            ))],
                          content: Text('iconic music is an application to listen to master music, eg: AC/DC, Michael Jackson, Qeen, etc.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                            )),
                          backgroundColor: colorsPalette[1],
                        ));
                      },
                      icon: const Icon(Icons.info, color: Colors.white),
                    ),
                    SizedBox(width: 10)
                  ])
            ])),
        bottomNavigationBar: Container(
            height: 80,
            child: CustomPaint(
                painter: customNavShape(bgColor: colorsPalette[1], colors: [colorsPalette[0], colorsPalette[3],colorsPalette[1], colorsPalette[3]]),
                child: NavigationBar(
                    onDestinationSelected: (int index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
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
        body: [Music(audioHandler: widget.audioHandler),
          Favorite(audioHandler: widget.audioHandler)][currentIndex]);
  }
}
