import 'package:flutter/material.dart';

class ADHDResultScreen extends StatelessWidget {
  final String conclusion;
  final String explanation;
  final String suggestions;
  final String important;
  final String disclaimer;

  const ADHDResultScreen({
    super.key,
    required this.conclusion,
    required this.explanation,
    required this.suggestions,
    required this.important,
    required this.disclaimer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADHD Assessment Result'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[100], // Light background for better contrast
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildHeader(),
                  _buildResultCard(
                      "🟣 Conclusion", conclusion, Colors.purple[100]!),
                  _buildResultCard(
                      "🔍 Explanation", explanation, Colors.blue[100]!),
                  _buildResultCard(
                      "✅ Suggestions", suggestions, Colors.green[100]!),
                  _buildResultCard("⚠️ Important Considerations", important,
                      Colors.orange[100]!),
                  _buildResultCard(
                      "📢 Disclaimer", disclaimer, Colors.red[100]!),
                ],
              ),
            ),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your ADHD Assessment Results",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple),
        ),
        const SizedBox(height: 8),
        const Text(
          "Below is a detailed breakdown of your assessment:",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildResultCard(String title, String content, Color bgColor) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: bgColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                  fontSize: 16, height: 1.5, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Colors.deepPurple,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            "Back to Test",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
