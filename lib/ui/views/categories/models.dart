class Music {
  final String title;
  final String description;
  final String youtubeLink;
  final String spotifyLink;

  Music({
    required this.title,
    required this.description,
    required this.youtubeLink,
    required this.spotifyLink,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      title: json['title'],
      description: json['description'] ?? '',
      youtubeLink: json['youtubeLink'],
      spotifyLink: json['spotifyLink'] ?? 'Not available',
    );
  }
}
