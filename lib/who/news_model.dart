import 'package:xml/xml.dart';

class NewsArticle {
  final String title;
  final String description;
  final String link;
  final String pubDate;
  final String? imageUrl;

  NewsArticle({
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
    this.imageUrl,
  });

  factory NewsArticle.fromXml(XmlElement xml) {
    String? imageUrl;

    // ✅ Try extracting from <media:content>
    final mediaContent = xml.findElements('media:content');
    if (mediaContent.isNotEmpty) {
      imageUrl = mediaContent.first.getAttribute('url');
    }

    // ✅ Try extracting from <enclosure>
    if (imageUrl == null || imageUrl.isEmpty) {
      final enclosure = xml.findElements('enclosure');
      if (enclosure.isNotEmpty) {
        imageUrl = enclosure.first.getAttribute('url');
      }
    }

    // ✅ Try extracting from <description> (WHO might use CDATA)
    final descriptionElement = xml.findElements('description').firstOrNull;
    String descriptionText = descriptionElement?.text ?? "";

    if (imageUrl == null || imageUrl.isEmpty) {
      final RegExp regex = RegExp(r'<img[^>]+src="([^">]+)"');
      final match = regex.firstMatch(descriptionText);
      if (match != null) {
        imageUrl = match.group(1);
      }
    }

    // ✅ Debugging: Print extracted image URL
    print("Extracted Image URL: ${imageUrl ?? 'None found'}");

    return NewsArticle(
      title: xml.findElements('title').first.text,
      description: _stripHtmlTags(descriptionText),
      link: xml.findElements('link').first.text,
      pubDate: xml.findElements('pubDate').first.text,
      imageUrl: imageUrl ??
          "https://via.placeholder.com/600x300?text=No+Image", // Default Image
    );
  }

  // ✅ Strips HTML tags from description
  static String _stripHtmlTags(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
