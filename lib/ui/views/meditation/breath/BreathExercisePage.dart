// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tangullo/data/breathing_data.dart';
import '../../themedata/ThemeData.dart';
import 'BreathDetailPage.dart';

class BreathExercisePage extends StatelessWidget {
  const BreathExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Types of Breathing'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: BREATHINGDATA.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BreathDetailPage(
                    breathingData: BREATHINGDATA[index],
                    breathingInstruction: BREATHINGINSTRU[index],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 6,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        BREATHINGDATA[index].image,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            BREATHINGDATA[index].name,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: AppTheme
                                  .primaryColor[800], // Use the primary color
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Duration: ${BREATHINGDATA[index].duration} min',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
