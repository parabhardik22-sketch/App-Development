class Wallpaper {
  final String id;
  final String author;
  final String imageUrl;

  Wallpaper({
    required this.id,
    required this.author,
    required this.imageUrl,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      id: json['id'],
      author: json['author'],
      imageUrl: json['download_url'],
    );
  }
}
