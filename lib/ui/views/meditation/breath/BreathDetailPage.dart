// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tangullo/ui/views/meditation/breath/BreathAnimationPage.dart';
import 'package:tangullo/modals/breathing_modal.dart';
import 'package:tangullo/modals/breathing_instructions.dart';

class BreathDetailPage extends StatelessWidget {
  final BreathingModal breathingData;
  final BreathingInstruc breathingInstruction;

  const BreathDetailPage({
    Key? key,
    required this.breathingData,
    required this.breathingInstruction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breathingData.name),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Enlarged Image with Shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  breathingData.image,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Breathing Exercise Title
            Center(
              child: Text(
                breathingData.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Instruction Content
            Text(
              breathingInstruction.breathingInstrc,
              style: const TextStyle(
                fontSize: 18.0,
                height: 1.6,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            // Start Button with Enhanced Style
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BreathAnimationPage(
                        breathingName: breathingData.name,
                        duration: int.parse(breathingData.duration),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.teal.withOpacity(0.3),
                ),
                child: const Text(
                  'Start Exercise',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
