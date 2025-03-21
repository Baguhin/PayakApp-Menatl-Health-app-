import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_service.dart';
import 'news_model.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  _NewsFeedPageState createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  late Future<List<NewsArticle>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = NewsService().fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "International Health News",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal[400],
        centerTitle: true,
        elevation: 3,
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorMessage();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildNoNewsMessage();
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemBuilder: (context, index) {
              final article = snapshot.data![index];
              return _buildNewsCard(article);
            },
          );
        },
      ),
    );
  }

  Widget _buildNewsCard(NewsArticle article) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _openNewsLink(article.link),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // News Title
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // News Description with Read More
              RichText(
                text: TextSpan(
                  text: article.description.isNotEmpty
                      ? article.description
                      : "No description available.",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  children: [
                    if (article.link.isNotEmpty)
                      TextSpan(
                        text: " Read more",
                        style: const TextStyle(
                          color: Colors.teal,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openNewsLink(article.link),
                      ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Published Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Published on: ${article.pubDate}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.teal),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 10),
            Text(
              "Failed to load news. Please check your internet connection and try again.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoNewsMessage() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "No news available at the moment.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _openNewsLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open the article.")),
      );
    }
  }
}
