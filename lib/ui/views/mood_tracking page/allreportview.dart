import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MoodReportView extends StatefulWidget {
  const MoodReportView({
    super.key,
    this.selectedMood,
    this.userId,
    required String mood,
    required List moodReports,
  });

  final String? selectedMood;
  final String? userId;

  @override
  _MoodReportViewState createState() => _MoodReportViewState();
}

class _MoodReportViewState extends State<MoodReportView>
    with SingleTickerProviderStateMixin {
  late String userId;
  final String _baseUrl = 'https://legit-backend-iqvk.onrender.com/api';

  // Report type selection
  String _selectedReportType = 'Daily';
  final List<String> _reportTypes = ['Daily', 'Weekly', 'Monthly'];

  // Animation controller
  late AnimationController _animationController;

  // Chart data
  Map<String, int> moodCounts = {};
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

  // Chart color mapping
  final Map<String, Color> moodColors = {
    "Joy": Colors.amber,
    "Fear": Colors.purple,
    "Disgust": Colors.green,
    "Anger": Colors.red,
    "Envy": Colors.lightGreen,
    "Embarrassment": Colors.pink,
    "Ennui": Colors.grey,
    "Nostalgia": Colors.teal,
    "Sadness": Colors.blue,
  };

  bool _isLoading = true;
  List<dynamic> _moodData = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _getUserId().then((_) => _fetchMoodData());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Get user ID from shared preferences or other storage
  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = widget.userId ?? prefs.getString('userId') ?? '';
    });
  }

  Future<void> _fetchMoodData() async {
    if (userId.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/moods/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          setState(() {
            _moodData = responseData['data'];
          });
          _processMoodData();
        } else {
          throw Exception('Failed to load mood data: ${responseData['error']}');
        }
      } else {
        throw Exception('Failed to load mood data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching mood data: $e');
    }
  }

  void _processMoodData() {
    // Reset counts
    moodCounts = {for (var mood in moods) mood: 0};

    final now = DateTime.now();
    DateTime startDate;

    // Set time range based on report type
    if (_selectedReportType == 'Daily') {
      startDate = DateTime(now.year, now.month, now.day);
    } else if (_selectedReportType == 'Weekly') {
      // Start from the beginning of the week (Monday)
      startDate = now.subtract(Duration(days: now.weekday - 1));
      startDate = DateTime(startDate.year, startDate.month, startDate.day);
    } else {
      // Monthly
      startDate = DateTime(now.year, now.month, 1);
    }

    for (var moodEntry in _moodData) {
      DateTime date = DateTime.parse(moodEntry['created_at']);
      String mood = moodEntry['mood_type'];

      if (moods.contains(mood) &&
          date.isAfter(startDate.subtract(const Duration(milliseconds: 1)))) {
        moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
      }
    }

    setState(() {
      _isLoading = false;
    });

    // Start animation after data is loaded
    _animationController.forward(from: 0.0);
  }

  // Helper method to get report title
  String _getReportTitle() {
    final now = DateTime.now();
    if (_selectedReportType == 'Daily') {
      return 'Mood Report for ${DateFormat.yMMMd().format(now)}';
    } else if (_selectedReportType == 'Weekly') {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      return 'Weekly Report (${DateFormat.MMMd().format(startOfWeek)} - ${DateFormat.MMMd().format(endOfWeek)})';
    } else {
      return 'Monthly Report for ${DateFormat.yMMM().format(now)}';
    }
  }

  // Bar chart with animation
  Widget _buildBarChart() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return BarChart(
          BarChartData(
            backgroundColor: Colors.transparent,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    );
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
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                  reservedSize: 60,
                ),
              ),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.shade200,
                  strokeWidth: 1,
                );
              },
            ),
            barGroups: moodCounts.entries.map((entry) {
              // Animation value influences the height of bars
              final animatedValue =
                  entry.value.toDouble() * _animationController.value;

              return BarChartGroupData(
                x: moods.indexOf(entry.key),
                barRods: [
                  BarChartRodData(
                    toY: animatedValue,
                    color: moodColors[entry.key] ?? Colors.blue,
                    width: 25,
                    borderRadius: BorderRadius.circular(6),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: moodCounts.values
                          .fold(0, (max, value) => value > max ? value : max)
                          .toDouble(),
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          swapAnimationDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }

  // Pie chart with animation
  Widget _buildPieChart() {
    // Calculate total moods
    final totalMoods = moodCounts.values.fold(0, (sum, count) => sum + count);

    // Filter out moods with zero count
    final nonZeroMoods =
        moodCounts.entries.where((entry) => entry.value > 0).toList();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return PieChart(
          PieChartData(
            sections: nonZeroMoods.map((entry) {
              final percentage =
                  totalMoods > 0 ? (entry.value / totalMoods) * 100 : 0;

              return PieChartSectionData(
                color: moodColors[entry.key] ?? Colors.blue,
                value: entry.value.toDouble(),
                title:
                    percentage >= 5 ? '${percentage.toStringAsFixed(1)}%' : '',
                radius: 120 * _animationController.value,
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            }).toList(),
            centerSpaceRadius: 30,
            sectionsSpace: 2,
          ),
          swapAnimationDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }

  // Legend for pie chart
  Widget _buildChartLegend() {
    final nonZeroMoods =
        moodCounts.entries.where((entry) => entry.value > 0).toList();

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: nonZeroMoods.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: moodColors[entry.key] ?? Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${entry.key} (${entry.value})',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  // Line chart for trend analysis
  Widget _buildLineChart() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: moodCounts.entries.map((entry) {
                  return FlSpot(moods.indexOf(entry.key).toDouble(),
                      entry.value.toDouble() * _animationController.value);
                }).toList(),
                isCurved: true,
                barWidth: 3,
                color: Colors.purple,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.purple.withOpacity(0.2),
                ),
              ),
            ],
            gridData: const FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.black87),
                    );
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
                            style: const TextStyle(
                                fontSize: 10, color: Colors.black87),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                  reservedSize: 60,
                ),
              ),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
          ),
        );
      },
    );
  }

  // Summary stats card
  Widget _buildSummaryCard() {
    final totalEntries = moodCounts.values.fold(0, (sum, count) => sum + count);

    // Find most frequent mood
    String topMood = "None";
    int topCount = 0;

    moodCounts.forEach((mood, count) {
      if (count > topCount) {
        topCount = count;
        topMood = mood;
      }
    });

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    'Total Entries',
                    totalEntries.toString(),
                    Icons.format_list_numbered,
                    Colors.blue,
                  ),
                  const SizedBox(width: 24),
                  _buildSummaryItem(
                    'Top Mood',
                    topMood,
                    Icons.trending_up,
                    moodColors[topMood] ?? Colors.orange,
                  ),
                  const SizedBox(width: 24),
                  _buildSummaryItem(
                    'Mood Variety',
                    '${moodCounts.values.where((count) => count > 0).length}/${moods.length}',
                    Icons.pie_chart,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mood Reports',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  await _fetchMoodData();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      const SizedBox(height: 16),

                      // Report type selector
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _reportTypes.map((type) {
                            final isSelected = type == _selectedReportType;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedReportType = type;
                                  });
                                  _fetchMoodData();
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.deepPurple
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black54,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Summary card
                      _buildSummaryCard(),

                      const SizedBox(height: 24),

                      // Bar chart card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getReportTitle(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Mood distribution for the ${_selectedReportType.toLowerCase()} period',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 300,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: moodCounts.length * 60.0,
                                    child: _buildBarChart(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Pie chart card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mood Distribution',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Percentage breakdown of your moods',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 300,
                                child: _buildPieChart(),
                              ),
                              const SizedBox(height: 16),
                              _buildChartLegend(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Line chart card for trend analysis
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mood Trend',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Visualization of mood frequency',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 300,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: moodCounts.length * 60.0,
                                    child: _buildLineChart(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
