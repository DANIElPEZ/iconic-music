import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class audioHandler extends BaseAudioHandler {
  final AudioPlayer audioPlayer= AudioPlayer();
  StreamController<bool>? onCompletionController;
  audioHandler() {
    onCompletionController= StreamController<bool>();
    listenToPlayerState();
  }

   Stream<bool> get onCompletionStream => onCompletionController?.stream??Stream.value(false);

  Future<void> setAudio(
      String musicUrl, String title, String artist) async {

    try {
      await audioPlayer.setUrl(musicUrl);
      mediaItem.add(MediaItem(
        id: musicUrl,
        title: title,
        artist: artist,
        duration: audioPlayer.duration,
      ));
      play();
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  void listenToPlayerState() {
    audioPlayer.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      final processingState = mapProcessingState(playerState.processingState);

      playbackState.add(playbackState.value.copyWith(
        controls: [
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop
        ],
        processingState: processingState,
        playing: playing,
        updatePosition: audioPlayer.position,
      ));
      // Notifica si la música ha terminado
      if (processingState == AudioProcessingState.completed) {
        onCompletionController?.add(true);
        stop();
      }
    });

    audioPlayer.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });

    audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        mediaItem.add(mediaItem.value?.copyWith(duration: duration));
      }
    });
  }

  AudioProcessingState mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        return AudioProcessingState.idle;
    }
  }

  @override
  Future<void> play() async {
    await audioPlayer.play();
    super.play();
  }

  @override
  Future<void> pause() async {
    await audioPlayer.pause();
    super.pause();
  }

  @override
  Future<void> stop() async {
    try {
      await audioPlayer.stop();

      playbackState.add(playbackState.value.copyWith(
          controls: [],
          processingState: AudioProcessingState.idle,
          playing: false));
      await super.stop();
    }catch(e){
      print('Error stopping player: $e');
    }
  }

  @override
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
    super.seek(position);
  }
}