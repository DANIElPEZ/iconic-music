import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconicmusic/views/Home_view.dart';
import 'package:iconicmusic/repository/music_repository.dart';
import 'package:iconicmusic/blocs/music/music_bloc.dart';
import 'package:iconicmusic/repository/search_repository.dart';
import 'package:iconicmusic/blocs/search/search_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loadServices();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

Future<void> loadServices() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_KEY'] ?? '');
  await MobileAds.instance.initialize();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MusicRepository>(
            create: (context) => MusicRepository()),
        RepositoryProvider<SearchRepository>(
            create: (context) => SearchRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<musicBloc>(
              create: (context) => musicBloc(
                  musicRepository:
                      RepositoryProvider.of<MusicRepository>(context))),
          BlocProvider<SearchBloc>(
              create: (context) => SearchBloc(
                  searchRepository:
                  RepositoryProvider.of<SearchRepository>(context)))
        ],
        child: Builder(builder: (context) {
          return SafeArea(
            child: MaterialApp(
                builder: (context, child) {
                  return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(1.0)),
                      child: SafeArea(child: child!));
                },
                home: HomePage(),
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    useMaterial3: true,
                    navigationBarTheme: NavigationBarThemeData(
                        labelTextStyle: WidgetStateProperty.resolveWith(
                            (states) => const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))))),
          );
        }),
      ),
    );
  }
}
