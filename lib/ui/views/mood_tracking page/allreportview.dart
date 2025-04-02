import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodReportView extends StatefulWidget {
  const MoodReportView(
      {super.key,
      required String mood,
      required String userId,
      required String selectedMood});

  @override
  _MoodReportViewState createState() => _MoodReportViewState();
}

class _MoodReportViewState extends State<MoodReportView> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, int> dailyMoodCount = {};
  final List<String> moods = [
    "Joy",
    "Fear",
    "Disgust",
    "Anger",
    "Envy",
    "Embarrassment",
    "Ennui",
    "Nostalgia",
    "Sadness"
  ];

  @override
  void initState() {
    super.initState();
    _fetchMoodData();
  }

  void _fetchMoodData() async {
    final moodDocs = await _firestore
        .collection('users')
        .doc(userId)
        .collection('moods')
        .orderBy('timestamp', descending: true)
        .get();

    final now = DateTime.now();
    dailyMoodCount = {for (var mood in moods) mood: 0};

    for (var doc in moodDocs.docs) {
      Timestamp ts = doc['timestamp'];
      DateTime date = ts.toDate();
      String mood = doc['mood'];

      if (moods.contains(mood) &&
          date.day == now.day &&
          date.month == now.month &&
          date.year == now.year) {
        dailyMoodCount[mood] = (dailyMoodCount[mood] ?? 0) + 1;
      }
    }

    setState(() {});
  }

  Widget _buildChart(Map<String, int> moodData, String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: moodData.length * 50.0,
                  child: BarChart(_generateBarData(moodData)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartData _generateBarData(Map<String, int> moodData) {
    return BarChartData(
      backgroundColor: Colors.transparent,
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(value.toInt().toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.black87));
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < moods.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      moods[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                );
              }
              return Container();
            },
            reservedSize: 60,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: true, drawVerticalLine: false),
      barGroups: moodData.entries.map((entry) {
        return BarChartGroupData(
          x: moods.indexOf(entry.key),
          barRods: [
            BarChartRodData(
              toY: entry.value.toDouble(),
              color: Colors.blueAccent,
              width: 30,
              borderRadius: BorderRadius.circular(6),
            )
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mood Reports',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildChart(dailyMoodCount, 'Daily Mood Report'),
            ],
          ),
        ),
      ),
    );
  }
}
