import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_model.dart';

class NewsService {
  final String apiUrl = "https://legit-backend-iqvk.onrender.com/api/news";

  Future<List<NewsArticle>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print("News API Response: ${response.body}"); // Debug print
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => NewsArticle.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load news: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news: $e"); // Debug print
      throw Exception("Failed to load news: $e");
    }
  }
}
