import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodReportView extends StatelessWidget {
  final String userId;

  const MoodReportView(
      {Key? key,
      required this.userId,
      required String mood,
      required String selectedMood})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hourly Mood Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildHourlyMoodChart(),
            const SizedBox(height: 20),
            const Text(
              'Daily Mood Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDailyMoodChart(),
            const SizedBox(height: 20),
            const Text(
              'Weekly Mood Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildWeeklyMoodChart(),
            const SizedBox(height: 20),
            const Text(
              'Monthly Mood Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildMonthlyMoodChart(),
          ],
        ),
      ),
    );
  }

  // Dummy data for hourly mood report
  LineChartData _getHourlyMoodData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      maxX: 23,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 1), // Example data point
            const FlSpot(1, 3),
            const FlSpot(2, 2),
            const FlSpot(3, 4),
            // Add more data points as needed
          ],
          isCurved: true,
          color: Colors.blue, // Updated to use 'color'
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  Widget _buildHourlyMoodChart() {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(_getHourlyMoodData()),
    );
  }

  // Dummy data for daily mood report
  BarChartData _getDailyMoodData() {
    return BarChartData(
      barGroups: [
        BarChartGroupData(
            x: 0, barRods: [BarChartRodData(toY: 3, color: Colors.blue)]),
        BarChartGroupData(
            x: 1, barRods: [BarChartRodData(toY: 1, color: Colors.blue)]),
        BarChartGroupData(
            x: 2, barRods: [BarChartRodData(toY: 4, color: Colors.blue)]),
        // Add more data points as needed
      ],
    );
  }

  Widget _buildDailyMoodChart() {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(_getDailyMoodData()),
    );
  }

  // Dummy data for weekly mood report
  PieChartData _getWeeklyMoodData() {
    return PieChartData(
      sections: [
        PieChartSectionData(value: 25, color: Colors.blue, title: 'Happy'),
        PieChartSectionData(value: 35, color: Colors.red, title: 'Sad'),
        PieChartSectionData(value: 20, color: Colors.green, title: 'Calm'),
        PieChartSectionData(value: 20, color: Colors.yellow, title: 'Anger'),
      ],
    );
  }

  Widget _buildWeeklyMoodChart() {
    return AspectRatio(
      aspectRatio: 2,
      child: PieChart(_getWeeklyMoodData()),
    );
  }

  // Dummy data for monthly mood report
  LineChartData _getMonthlyMoodData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      minX: 0,
      maxX: 30, // Assuming a month with 30 days
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 1), // Example data point
            const FlSpot(5, 3),
            const FlSpot(10, 2),
            const FlSpot(15, 4),
            // Add more data points as needed
          ],
          isCurved: true,
          color: Colors.blue, // Updated to use 'color'
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  Widget _buildMonthlyMoodChart() {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(_getMonthlyMoodData()),
    );
  }
}
