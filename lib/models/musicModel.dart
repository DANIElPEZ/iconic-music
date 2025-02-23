class Musicmodel {
  int id;
  String title;
  String artist;
  String file_url;
  String image_url;
  String url_lrc;

  Musicmodel(
      {required this.id,
      required this.title,
      required this.artist,
      required this.file_url,
      required this.image_url,
      required this.url_lrc});

  factory Musicmodel.fromJSON(Map<String, dynamic> json) {
    return Musicmodel(
        id: json['id'],
        title: json['title'],
        artist: json['artist'],
        file_url: json['file_url'],
        image_url: json['image_url'],
    url_lrc: json['url_lrc']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'file_url': file_url,
      'image_url': image_url,
      'url_lrc':url_lrc
    };
  }
}
