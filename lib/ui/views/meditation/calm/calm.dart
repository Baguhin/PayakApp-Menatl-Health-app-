import 'package:flutter/material.dart';

import 'package:tangullo/data/calm_data.dart';
import '../../themedata/ThemeData.dart';
import 'CalmDetailPage.dart';

class CalmExercisePage extends StatelessWidget {
  const CalmExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calm Exercises'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: CALMDATA.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Calmdetailpage(
                    CALMDATA: CALMDATA[index],
                    CALMINSTRUC: CALMINSTRUC[index],
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
                        CALMDATA[index].image,
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
                            CALMDATA[index].name,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor[800],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Duration: ${CALMDATA[index].duration} min',
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
