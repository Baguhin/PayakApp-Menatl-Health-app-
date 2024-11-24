// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tangullo/modals/calm_modal.dart';

import '../../../../modals/calm_instruction.dart';

class Calmdetailpage extends StatelessWidget {
  final CalmModal CALMDATA;
  final CalmInstructions CALMINSTRUC;

  const Calmdetailpage({
    Key? key,
    required this.CALMDATA,
    required this.CALMINSTRUC,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CALMDATA.name),
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
                  CALMDATA.image,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Breathing Exercise Title
            Center(
              child: Text(
                CALMDATA.name,
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
              CALMINSTRUC.instruction,
              style: const TextStyle(
                fontSize: 18.0,
                height: 1.6,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            // Start Button with Enhanced Style
          ],
        ),
      ),
    );
  }
}
