import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmartStress extends StatelessWidget {
  const SmartStress({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Stress Prediction",
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stress Level Indicator
            Text(
              "Your Stress Level:",
              style: GoogleFonts.alegreya(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            _buildStressLevelIndicator(),
            const SizedBox(height: 20),

            // Predictive Insights Section
            Text(
              "Predictive Insights:",
              style: GoogleFonts.alegreya(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            _buildPredictiveInsights(),
            const SizedBox(height: 20),

            // Stress-relief Action Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action on button press
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Relaxation Tips"),
                        content: const Text(
                            "Take a deep breath, relax, and stay present."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Take a Breather",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStressLevelIndicator() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.trending_up, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              "Moderate Stress",
              style: GoogleFonts.alegreya(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const LinearProgressIndicator(
              value: 0.6, // Change based on actual stress level
              minHeight: 8,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 10),
            const Text(
              "You are at a moderate stress level. Let's take some actions to reduce it!",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictiveInsights() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tips to Reduce Stress:",
            style: GoogleFonts.alegreya(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          _buildInsightItem("Take a 5-minute break"),
          _buildInsightItem("Practice deep breathing exercises"),
          _buildInsightItem("Try some light stretching or yoga"),
          _buildInsightItem("Drink a glass of water"),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle, size: 20, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
