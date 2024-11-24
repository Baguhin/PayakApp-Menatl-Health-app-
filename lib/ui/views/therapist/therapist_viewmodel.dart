import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class Therapist {
  final int id;
  final String name;
  final String location;
  final String specialty;

  Therapist({
    required this.id,
    required this.name,
    required this.location,
    required this.specialty,
  });

  factory Therapist.fromJson(Map<String, dynamic> json) {
    return Therapist(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      specialty: json['specialty'],
    );
  }
}

class TherapistViewModel extends BaseViewModel {
  List<Therapist> _therapists = [];
  List<Therapist> get therapists => _therapists;

  Future<void> fetchTherapists() async {
    const String url = 'http://192.168.43.161:8000/chatbot/api/therapists/';

    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _therapists = data.map((json) => Therapist.fromJson(json)).toList();
        notifyListeners();
      } else {
        debugPrint(
            'Failed to load therapists, status code: ${response.statusCode}');
        throw Exception('Failed to load therapists');
      }
    } catch (e) {
      debugPrint('Error fetching therapists: $e');
      if (e is SocketException) {
        debugPrint('SocketException: Check if the server is reachable.');
      } else if (e is HttpException) {
        debugPrint('HttpException: Check for HTTP-specific issues.');
      } else if (e is FormatException) {
        debugPrint('FormatException: Check if the response format is correct.');
      }
    }
  }
}

class TestApi extends StatelessWidget {
  const TestApi({Key? key}) : super(key: key);

  final String apiUrl = 'http://192.168.43.161:8000/chatbot/api/therapists/';

  Future<void> fetchTherapists() async {
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));
      debugPrint('Response status: ${response.statusCode}');
      debugPrint(
          'Response body: ${response.body}'); // Log the entire response body

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        for (var json in data) {
          final therapist = Therapist.fromJson(json);
          debugPrint(
              'Therapist: ${therapist.name}, Location: ${therapist.location}, Specialty: ${therapist.specialty}');
        }
      } else {
        debugPrint(
            'Failed to load therapists, status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching therapists: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchTherapists(); // Call the fetch function for testing

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test API'),
      ),
      body: const Center(
        child: Text('Check console for API response.'),
      ),
    );
  }
}
