import 'dart:ffi';

class musicState {
  musicState(
      {required this.musics,
      required this.artist,
      required this.title,
      required this.url_file,
      required this.url_image,
      required this.url_lrc,
      required this.loading});

  final List musics;
  final String title;
  final String artist;
  final String url_file;
  final String url_image;
  final String url_lrc;
  final Bool loading;

  factory musicState.initial() {
    return musicState(
        musics: [],
        artist: '',
        title: '',
        url_file: '',
        url_image: '',
        url_lrc: '',
        loading: true as Bool);
  }

  musicState copyWith(
      {List? musics,
      String? artist,
      String? title,
      String? url_file,
      String? url_image,
      String? url_lrc,
      Bool? loading}) {
    return musicState(
        musics: musics ?? this.musics,
        artist: artist ?? this.artist,
        title: title ?? this.title,
        url_file: url_file ?? this.url_file,
        url_image: url_image ?? this.url_image,
        url_lrc: url_lrc ?? this.url_lrc,
        loading: loading ?? this.loading);
  }
}
