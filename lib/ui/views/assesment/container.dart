import 'package:flutter/material.dart';
import 'package:tangullo/ui/views/assesment/adhd.dart';
import 'package:tangullo/ui/views/assesment/anxietytest.dart';
import 'package:tangullo/ui/views/assesment/bipolar.dart';
import 'package:tangullo/ui/views/assesment/depression.dart';
import 'package:tangullo/ui/views/assesment/eating.dart';
import 'package:tangullo/ui/views/assesment/ocdtest.dart';
import 'package:tangullo/ui/views/assesment/ptsd.dart';
import 'package:tangullo/ui/views/assesment/stress.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tests = [
    {
      'name': 'Depression Test',
      'route': '/test/depression',
      'icon': 'assets/icons/depression.png',
      'color': Colors.blue.shade300,
      'description': 'Assess symptoms of depression',
    },
    {
      'name': 'Anxiety Test',
      'route': '/test/anxiety',
      'icon': 'assets/icons/anxiety.png',
      'color': Colors.green.shade300,
      'description': 'Evaluate anxiety levels',
    },
    {
      'name': 'OCD Test',
      'route': '/test/ocd',
      'icon': 'assets/icons/ocd.png',
      'color': Colors.amber.shade300,
      'description': 'Screen for obsessive-compulsive patterns',
    },
    {
      'name': 'Stress Test',
      'route': '/test/stress',
      'icon': 'assets/icons/stress.png',
      'color': Colors.red.shade300,
      'description': 'Measure your stress levels',
    },
    {
      'name': 'Bipolar Disorder Test',
      'route': '/test/bipolar',
      'icon': 'assets/icons/bipolar.png',
      'color': Colors.purple.shade300,
      'description': 'Check for bipolar disorder symptoms',
    },
    {
      'name': 'PTSD Test',
      'route': '/test/ptsd',
      'icon': 'assets/icons/ptsd.png',
      'color': Colors.teal.shade300,
      'description': 'Evaluate post-traumatic stress',
    },
    {
      'name': 'Eating Disorder Test',
      'route': '/test/eating',
      'icon': 'assets/icons/eating.png',
      'color': Colors.pink.shade300,
      'description': 'Screen for eating disorders',
    },
    {
      'name': 'ADHD Test',
      'route': '/test/adhd',
      'icon': 'assets/icons/adhd.png',
      'color': Colors.orange.shade300,
      'description': 'Assess attention deficit symptoms',
    },
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade500, Colors.purple.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.psychology, color: Colors.white, size: 30),
            const SizedBox(width: 12),
            Text(
              'PayakApp',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildWelcomeSection(),
                const SizedBox(height: 24),
                _buildSectionHeader('Assessment Tests'),
                const SizedBox(height: 16),
                Expanded(
                  child: isTablet
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: tests.length,
                          itemBuilder: _buildTestItem,
                        )
                      : ListView.builder(
                          itemCount: tests.length,
                          itemBuilder: _buildTestItem,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade100, Colors.purple.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.redAccent),
              const SizedBox(width: 10),
              Text(
                'Mental Health Assessment',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Take a step towards better mental health by assessing your condition with our scientifically-backed tests.',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.indigo.shade500,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Start your journey now',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.indigo.shade800,
      ),
    );
  }

  Widget _buildTestItem(BuildContext context, int index) {
    final test = tests[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: test['color'].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.pushNamed(context, test['route']);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: test['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(
                    test['icon'],
                    height: 32,
                    width: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test['name'],
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        test['description'],
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: test['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: test['color'],
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void main() {
    runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade100,
        fontFamily: 'Nunito',
      ),
      home: HomeScreen(),
      routes: {
        '/test/depression': (context) => const DepressionTestScreen(),
        '/test/anxiety': (context) => const AnxietyTestScreen(),
        '/test/ocd': (context) => const OCDTestScreen(),
        '/test/stress': (context) => const StressTestScreen(),
        '/test/bipolar': (context) => const BipolarTestScreen(),
        '/test/ptsd': (context) => const PTSDTestScreen(),
        '/test/eating': (context) => const EatingDisorderTestScreen(),
        '/test/adhd': (context) => const ADHDTestScreen(),
      },
    ));
  }
}
