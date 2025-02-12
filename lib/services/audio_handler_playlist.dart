import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioServiceHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioServiceHandler() {
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && queue.value.isNotEmpty) {
        mediaItem.add(queue.value[index]); // Actualiza la notificación
      }
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop(); // Detiene la reproducción cuando termina la lista
      }
    });
    print('ejcutado inicio');
  }

  Future<void> loadPlaylist(List<String> urls) async {
    final playlist = ConcatenatingAudioSource(
      children: urls.map((url) => AudioSource.uri(Uri.parse(url))).toList(),
    );

    await _audioPlayer.setAudioSource(playlist);
    queue.add(urls
        .map((url) => MediaItem(id: url, title: url.split('/').last))
        .toList());
    print('cargando');
  }

  Future<void> startPlayback() async {
    if (_audioPlayer.processingState == ProcessingState.idle) {
      await _audioPlayer.play();
    }
    print('reproduciendo');
  }

  @override
  Future<void> play() => _audioPlayer.play();

  @override
  Future<void> pause() => _audioPlayer.pause();

  @override
  Future<void> stop() => _audioPlayer.stop();

  @override
  Future<void> skipToNext() => _audioPlayer.seekToNext();

  @override
  Future<void> skipToPrevious() => _audioPlayer.seekToPrevious();
}
