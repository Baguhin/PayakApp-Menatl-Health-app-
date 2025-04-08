import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tangullo/ui/views/home/home.dart'; // Assuming this is your home page
import 'package:google_fonts/google_fonts.dart';

class Assessment extends StatefulWidget {
  const Assessment({super.key});

  @override
  _AssessmentState createState() => _AssessmentState();
}

class _AssessmentState extends State<Assessment> {
  final List<bool?> answers =
      List.filled(40, null); // Updated for more questions
  int currentQuestionIndex = 0;

  // Questions with citations
  final List<List<String>> questions = [
    // Depression questions
    [
      'Are you having thoughts that you would be better off dead, or of hurting yourself?',
      'Are you having trouble concentrating on things such as reading the newspaper or watching TV?',
      'Are you feeling bad about yourself (e.g., feel like a failure or constantly let your family down)?',
      'Do you have a poor appetite or are you overeating?',
      'Are you feeling tired or having little energy?',
      'Are you having trouble falling or staying asleep, or sleeping too much?',
      'Are you feeling down, depressed, or hopeless?',
      'Do you have little interest or pleasure in doing things?',
    ],
    // Anxiety questions
    [
      'Are you feeling nervous, anxious, or on edge?',
      'Are you feeling unable to stop or control worrying?',
      'Are you worrying too much about different things?',
      'Are you having trouble relaxing?',
      'Are you so restless that it is hard to sit still?',
      'Are you feeling easily annoyed or irritable?',
      'Are you feeling as if something awful might happen?',
    ],
    // PTSD questions
    [
      'Are you having nightmares about a distressing event(s)?',
      'Are you trying hard not to think about a distressing event(s)?',
      'Do you feel constantly on guard, watchful, or easily startled?',
      'Do you feel numb or detached from people or activities?',
      'Do you feel guilty or unable to stop blaming yourself for a distressing event(s)?',
    ],
    // Schizophrenia questions
    [
      'Are you experiencing any brain fog?',
      'Are you struggling to remember to eat or drink water?',
      'Are your thoughts jumbled or are you unable to think clearly?',
      'Are you having trouble seeing things or seeing things that aren\'t there?',
      'Do you feel extremely tired?',
    ],
    // Addiction questions
    [
      'Are you using substances to numb any physical or emotional pain?',
      'Do you feel like you should cut down on your substance use?',
      'Are you feeling guilty about using substances?',
      'Is anyone criticizing your substance use?',
      'Do you feel that your substance use significantly decreases your ability to function?',
    ],
  ];

  // Citations for questions
  final List<List<String>> citations = [
    // Depression citations
    [
      'Source: PHQ-9',
      'Source: APA',
      'Source: PHQ-9',
      'Source: APA',
      'Source: NIMH',
      'Source: PHQ-9',
      'Source: PHQ-9',
      'Source: APA',
    ],
    // Anxiety citations
    [
      'Source: GAD-7',
      'Source: GAD-7',
      'Source: GAD-7',
      'Source: GAD-7',
      'Source: NIMH',
      'Source: APA',
      'Source: GAD-7',
    ],
    // PTSD citations
    [
      'Source: PTSD Checklist for DSM-5',
      'Source: PTSD Checklist for DSM-5',
      'Source: APA',
      'Source: APA',
      'Source: PTSD Checklist for DSM-5',
    ],
    // Schizophrenia citations
    [
      'Source: APA',
      'Source: APA',
      'Source: NIMH',
      'Source: APA',
      'Source: APA',
    ],
    // Addiction citations
    [
      'Source: CAGE Questionnaire',
      'Source: CAGE Questionnaire',
      'Source: APA',
      'Source: APA',
      'Source: APA',
    ],
  ];

  String getResults() {
    int score = answers.where((answer) => answer == true).length;
    int totalQuestions = questions.expand((q) => q).length;

    double percentage = (score / totalQuestions) * 100;

    if (percentage >= 75) {
      return "High concern: You may be experiencing significant mental health challenges. Consider seeking professional help.\n\nYour score: ${percentage.toStringAsFixed(1)}%";
    } else if (percentage >= 50) {
      return "Moderate concern: You may have some anxiety or depressive symptoms. Consider self-care and relaxation.\n\nYour score: ${percentage.toStringAsFixed(1)}%";
    } else {
      return "Low concern: You appear to be in a good state of mental health. Keep it up!\n\nYour score: ${percentage.toStringAsFixed(1)}%";
    }
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(userName: ''), // Pass user name if needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalQuestions = questions.expand((q) => q).length;
    double currentPercentage = (currentQuestionIndex / totalQuestions);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'Mental Health Assessment',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (currentQuestionIndex > 0) {
              setState(() {
                currentQuestionIndex--;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: currentQuestionIndex < totalQuestions
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 130.0,
                    lineWidth: 15.0,
                    animation: true,
                    percent: currentPercentage,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${currentQuestionIndex + 1}/$totalQuestions",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4A90E2),
                          ),
                        ),
                        Text(
                          "Questions",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: const Color(0xFF4A90E2),
                    backgroundColor: const Color(0xFFE6E8EB),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          questions.expand((q) => q).elementAt(currentQuestionIndex),
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          citations.expand((c) => c).elementAt(currentQuestionIndex),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFF666666),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildGradientButton(
                        text: 'No',
                        colors: const [Color(0xFFF44336), Color(0xFFE57373)],
                        onPressed: () {
                          setState(() {
                            answers[currentQuestionIndex] = false;
                            currentQuestionIndex++;
                          });
                        },
                      ),
                      _buildGradientButton(
                        text: 'Yes',
                        colors: const [Color(0xFF4CAF50), Color(0xFF81C784)],
                        onPressed: () {
                          setState(() {
                            answers[currentQuestionIndex] = true;
                            currentQuestionIndex++;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              )
            : _buildResultsPage(),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsPage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.assessment_rounded,
            size: 72,
            color: Color(0xFF4A90E2),
          ),
          const SizedBox(height: 24),
          Text(
            'Assessment Complete',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            getResults(),
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: const Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildGradientButton(
            text: 'Return Home',
            colors: const [Color(0xFF4A90E2), Color(0xFF64B5F6)],
            onPressed: navigateToHome,
          ),
        ],
      ),
    );
  }
}