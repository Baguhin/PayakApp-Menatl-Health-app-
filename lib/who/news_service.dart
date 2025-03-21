import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'news_model.dart';

class NewsService {
  final String whoNewsUrl = "https://www.who.int/rss-feeds/news-english.xml";

  Future<List<NewsArticle>> fetchNews() async {
    final response = await http.get(Uri.parse(whoNewsUrl));

    if (response.statusCode == 200) {
      print("WHO RSS Feed Response:\n${response.body}"); // Debugging raw XML

      final document = xml.XmlDocument.parse(response.body);
      final items = document.findAllElements("item");

      return items.map((element) => NewsArticle.fromXml(element)).toList();
    } else {
      throw Exception("Failed to load news");
    }
  }
}
