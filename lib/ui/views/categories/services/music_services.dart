import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models.dart';

class MusicService {
  final String apiUrl =
      'https://legit-backend-iqvk.onrender.com/api/music/meditation-music';

  Future<List<Music>> fetchMeditationMusic(String preference) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?preference=$preference'),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['music'];
        return data.map((item) => Music.fromJson(item)).toList();
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load music');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching music data');
    }
  }
}
