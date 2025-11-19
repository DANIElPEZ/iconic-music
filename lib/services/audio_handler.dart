import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class audioHandler extends BaseAudioHandler {
  final AudioPlayer audioPlayer= AudioPlayer();
  final List<MediaItem> playlist=[];
  int currentIndex=-1;
  bool isPlaylistMode=false;

  StreamController<bool>? onCompletionController;
  audioHandler() {
    onCompletionController= StreamController<bool>();
    listenToPlayerState();
  }

   Stream<bool> get onCompletionStream => onCompletionController?.stream??Stream.value(false);

  Future<void> playSingleTrack(
      String musicUrl, String title, String artist, image_url) async {

    isPlaylistMode=false;
    try {
      await audioPlayer.setUrl(musicUrl);
      mediaItem.add(MediaItem(
        id: musicUrl,
        title: title,
        artist: artist,
        artUri: Uri.parse(image_url),
        duration: audioPlayer.duration,
      ));
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  Future<void> setPlaylist(List<MediaItem> newPlaylist)async{
    isPlaylistMode=true;
    stop();
    playlist.clear();
    playlist.addAll(newPlaylist);
    currentIndex=0;
    await loadCurrentTrack();
  }

  Future<void> loadCurrentTrack() async{
    if(currentIndex<0 || currentIndex>=playlist.length) return;

    final mediaItem=playlist[currentIndex];
    try{
      await audioPlayer.setUrl(mediaItem.id);
      this.mediaItem.add(mediaItem);
      play();
    }catch(e){
      print(e);
    }
  }

  Future<void> next() async{
    if(!isPlaylistMode || playlist.isEmpty) return;

    if(currentIndex < playlist.length-1){
      currentIndex++;
      await loadCurrentTrack();
    }else{
      stop();
    }
  }

  Future<void> previous()async{
    if(!isPlaylistMode || playlist.isEmpty) return;

    if(currentIndex>0){
      currentIndex--;
      await loadCurrentTrack();
    }else{
      stop();
    }
  }

  Future<void> playAtIndex(int index) async{
    if(!isPlaylistMode || index<0 || index>=playlist.length) return;
    currentIndex=index;
    await loadCurrentTrack();
  }

  void listenToPlayerState() {
    audioPlayer.playerStateStream.listen((playerState) {

      final playing = playerState.playing;
      final processingState = mapProcessingState(playerState.processingState);

      playbackState.add(playbackState.value.copyWith(
        controls: [
          if(isPlaylistMode) MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          if(isPlaylistMode) MediaControl.skipToNext
        ],
        processingState: processingState,
        playing: playing,
        updatePosition: audioPlayer.position,
      ));
      // Notifica si la música ha terminado
      if (processingState == AudioProcessingState.completed) {
        onCompletionController?.add(true);
        if(isPlaylistMode){
          next();
        }else {
          stop();
        }
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
      await AudioService.stop();
    }catch(e){
      print('Error stopping player: $e');
    }
  }

  @override
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
    super.seek(position);
  }

  @override
  Future<void> skipToNext()async{
    if(isPlaylistMode){
      await next();
      super.skipToNext();
    }
  }

  @override
  Future<void> skipToPrevious() async{
    if(isPlaylistMode){
      await previous();
      super.skipToPrevious();
    }
  }

  @override
  Future<void> onTaskRemoved() async {
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
      playing: false,
      controls: [],
    ));
    try {
      await audioPlayer.stop();
      await AudioService.stop();
    } catch (e) {
    }
    return super.onTaskRemoved();
  }
}