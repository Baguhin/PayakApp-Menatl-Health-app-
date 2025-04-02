class NewsArticle {
  final String title;
  final String description;
  final String link;
  final String pubDate;
  final String category;
  final String relevance;

  NewsArticle({
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
    required this.category,
    required this.relevance,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['summary'] ?? '',
      link: json['link'] ?? '#',
      pubDate: json['pubDate'] ?? DateTime.now().toIso8601String(),
      category: json['category'] ?? '',
      relevance: json['relevance'] ?? '',
    );
  }
}
