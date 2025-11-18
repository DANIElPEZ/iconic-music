abstract class musicEvent {}

class LoadMusics extends musicEvent {}

class LoadFavoriteMusics extends musicEvent{}

class LoadMusic extends musicEvent {
  LoadMusic({required this.id,
    required this.title,
    required this.artist,
    required this.url_file,
    required this.url_image,
    required this.url_lrc});
  final int id;
  final String title;
  final String artist;
  final String url_file;
  final String url_image;
  final String url_lrc;
}

class AddFavorite extends musicEvent {}

class DeleteFavorite extends musicEvent {}

class DownloadMusic extends musicEvent {}

class LikedMusic extends musicEvent{}

class IsDownloadedMusic extends musicEvent{}