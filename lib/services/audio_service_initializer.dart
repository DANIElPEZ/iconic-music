import 'package:audio_service/audio_service.dart';
import 'package:iconicmusic/services/audio_handler.dart';

final Future<AudioHandler> audioHandlerinit=initAudioHandler();

Future<AudioHandler> initAudioHandler() async {
    return await AudioService.init(
        builder: () =>
            audioHandler(),
        config: const AudioServiceConfig(
            androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
            androidNotificationChannelName: 'Audio playback',
            androidNotificationOngoing: true,
            androidStopForegroundOnPause: true));
}