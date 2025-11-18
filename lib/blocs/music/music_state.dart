class musicState {
  musicState(
      {required this.musics,
      required this.favoriteMusics,
      required this.isLiked,
      required this.isDownloaded,
      required this.loading,
      required this.id,
      required this.title,
      required this.artist,
      required this.url_file,
      required this.url_image,
      required this.url_lrc});

  final List musics;
  final List favoriteMusics;
  final bool isLiked;
  final bool isDownloaded;
  final bool loading;

  //replay view
  final int id;
  final String title;
  final String artist;
  final String url_file;
  final String url_image;
  final String url_lrc;

  factory musicState.initial() {
    return musicState(
        musics: [],
        favoriteMusics: [],
        isLiked: false,
        isDownloaded: false,
        loading: true,
        id: 0,
        url_image: '',
        url_lrc: '',
        url_file: '',
        title: '',
        artist: '');
  }

  musicState copyWith(
      {List? musics,
      List? favoriteMusics,
      bool? isLiked,
      bool? isDownloaded,
      bool? loading,
      int? id,
      String? title,
      String? artist,
      String? url_file,
      String? url_image,
      String? url_lrc}) {
    return musicState(
        musics: musics ?? this.musics,
        favoriteMusics: favoriteMusics ?? this.favoriteMusics,
        isLiked: isLiked ?? this.isLiked,
        isDownloaded: isDownloaded ?? this.isDownloaded,
        loading: loading ?? this.loading,
        id: id ?? this.id,
        artist: artist ?? this.artist,
        title: title ?? this.title,
        url_file: url_file ?? this.url_file,
        url_lrc: url_lrc ?? this.url_lrc,
        url_image: url_image ?? this.url_image);
  }
}
