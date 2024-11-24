class Music {
  final String title;
  final String artist;
  final String imageUrl; // For album cover image
  final String musicUrl; // For music URL

  Music({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.musicUrl, // Include this line
  });
}
