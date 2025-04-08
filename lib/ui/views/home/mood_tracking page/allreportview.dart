import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MoodReportView extends StatefulWidget {
  final String mood;
  final String userId;
  final String selectedMood;

  const MoodReportView({
    Key? key,
    required this.mood,
    required this.userId,
    required this.selectedMood,
  }) : super(key: key);

  @override
  State<MoodReportView> createState() => _MoodReportViewState();
}

class _MoodReportViewState extends State<MoodReportView> {
  final Map<String, Color> moodColors = {
    'Joy': const Color(0xFFFFD700),
    'Fear': const Color(0xFF3F51B5),
    'Disgust': const Color(0xFF4CAF50),
    'Anger': const Color(0xFFF44336),
    'Envy': const Color(0xFF556B2F),
    'Embarrassment': const Color(0xFFFF5722),
    'Ennui': const Color(0xFF9E9E9E),
    'Nostalgia': const Color(0xFF795548),
    'Sadness': const Color(0xFF2196F3),
  };

  get math => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Mood Analytics',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('moods')
            .orderBy('timestamp', descending: true)
            .limit(30)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final moodData = snapshot.data!.docs;
          final moodCounts = _calculateMoodCounts(moodData);
          final weeklyMoodData = _calculateWeeklyMoodData(moodData);

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(moodCounts),
                  const SizedBox(height: 24),
                  _buildPieChartSection(moodCounts),
                  const SizedBox(height: 24),
                  _buildWeeklyTrendSection(weeklyMoodData),
                  const SizedBox(height: 24),
                  _buildRecentMoodsSection(moodData),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, int> moodCounts) {
    String dominantMood =
        moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            moodColors[dominantMood]!.withOpacity(0.8),
            moodColors[dominantMood]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: moodColors[dominantMood]!.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Summary',
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Most frequent mood: $dominantMood',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartSection(Map<String, int> moodCounts) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mood Distribution',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: _generatePieSections(moodCounts),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendSection(List<Map<String, dynamic>> weeklyData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Trend',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < weeklyData.length) {
                          return Text(
                            weeklyData[value.toInt()]['day'],
                            style: GoogleFonts.montserrat(fontSize: 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: weeklyData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value['count'].toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Theme.of(context).primaryColor,
                    barWidth: 4,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generatePieSections(Map<String, int> moodCounts) {
    final total = moodCounts.values.fold(0, (sum, count) => sum + count);
    return moodCounts.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: moodColors[entry.key],
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildRecentMoodsSection(List<QueryDocumentSnapshot> moodData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Moods',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: math.min(5, moodData.length),
            itemBuilder: (context, index) {
              final mood = moodData[index].get('mood') as String;
              final timestamp = moodData[index].get('timestamp') as Timestamp;
              final date =
                  DateFormat('MMM d, y - h:mm a').format(timestamp.toDate());

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: moodColors[mood]?.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: moodColors[mood],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getMoodIcon(mood),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mood,
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            date,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getMoodIcon(String mood) {
    switch (mood) {
      case 'Joy':
        return Icons.sentiment_very_satisfied;
      case 'Fear':
        return Icons.sentiment_very_dissatisfied;
      case 'Disgust':
        return Icons.sick;
      case 'Anger':
        return Icons.mood_bad;
      case 'Envy':
        return Icons.remove_red_eye;
      case 'Embarrassment':
        return Icons.face;
      case 'Ennui':
        return Icons.sentiment_neutral;
      case 'Nostalgia':
        return Icons.history;
      case 'Sadness':
        return Icons.sentiment_dissatisfied;
      default:
        return Icons.mood;
    }
  }

  Map<String, int> _calculateMoodCounts(List<QueryDocumentSnapshot> moodData) {
    final counts = <String, int>{};
    for (var doc in moodData) {
      final mood = doc.get('mood') as String;
      counts[mood] = (counts[mood] ?? 0) + 1;
    }
    return counts;
  }

  List<Map<String, dynamic>> _calculateWeeklyMoodData(
      List<QueryDocumentSnapshot> moodData) {
    final weeklyData = <String, int>{};
    final now = DateTime.now();
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (var doc in moodData) {
      final timestamp = doc.get('timestamp') as Timestamp;
      final date = timestamp.toDate();
      if (now.difference(date).inDays <= 7) {
        final dayName = weekDays[date.weekday - 1];
        weeklyData[dayName] = (weeklyData[dayName] ?? 0) + 1;
      }
    }

    return weekDays.map((day) {
      return {
        'day': day,
        'count': weeklyData[day] ?? 0,
      };
    }).toList();
  }
}
