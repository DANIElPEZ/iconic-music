import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iconicmusic/provider/musicProvider.dart';
import 'package:iconicmusic/utils/audio_service_initializer.dart';
import 'package:iconicmusic/views/Home.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loadServices();
  final audioHandler=await initAudioHandler();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => musicProvider())],
        child: MyApp(audioHandler: audioHandler)));
  });
}

Future<void> loadServices() async{
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_KEY'] ?? '');
  await MobileAds.instance.initialize();
}

class MyApp extends StatefulWidget {
  MyApp({required this.audioHandler});
  final AudioHandler audioHandler;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData()async{
    final music=Provider.of<musicProvider>(context, listen: false);
    await music.checkConnection();
    await Future.delayed(Duration(microseconds: 900));
    await music.fetchMusics();
    await music.getMyMusics();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
          home: HomePage(audioHandler: widget.audioHandler),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              useMaterial3: true,
              navigationBarTheme: NavigationBarThemeData(
                  labelTextStyle: WidgetStateProperty.resolveWith((states) =>
                      const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))))),
    );
  }
}