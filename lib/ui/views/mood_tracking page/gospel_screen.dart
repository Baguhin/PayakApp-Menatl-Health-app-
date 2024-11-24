import 'package:flutter/material.dart';
import 'dart:math';

class GospelScreen extends StatelessWidget {
  final String moodType;

  const GospelScreen({Key? key, required this.moodType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define lists of gospel verses for each mood
    final Map<String, List<String>> gospelVerses = {
      'Sadness': [
        '“The Lord is close to the brokenhearted and saves those who are crushed in spirit.” - Psalm 34:18',
        '“He will wipe every tear from their eyes.” - Revelation 21:4',
        '“Weeping may endure for a night, but joy comes in the morning.” - Psalm 30:5',
      ],
      'Anger': [
        '“Be angry, and do not sin; do not let the sun go down on your anger.” - Ephesians 4:26',
        '“A gentle answer turns away wrath, but a harsh word stirs up anger.” - Proverbs 15:1',
        '“Fools give full vent to their rage, but the wise bring calm in the end.” - Proverbs 29:11',
      ],
      'Joy': [
        '“The joy of the Lord is your strength.” - Nehemiah 8:10',
        '“Rejoice in the Lord always; again I will say, Rejoice.” - Philippians 4:4',
        '“You make known to me the path of life; in your presence there is fullness of joy.” - Psalm 16:11',
        '“For You make me glad by Your deeds, O Lord; I sing for joy at what Your hands have done.” - Psalm 92:4',
      ],
      'Fear': [
        '“For I, the Lord your God, hold your right hand; it is I who say to you, “Fear not, I am the one who helps you.” - Isaiah 41:13',
        '“When I am afraid, I put my trust in you.” - Psalm 56:3',
        '“There is no fear in love, but perfect love casts out fear.” - 1 John 4:18',
      ],
      'Envy': [
        '“Do not let your heart envy sinners, but always be zealous for the fear of the Lord.” - Proverbs 23:17',
        '“For where you have envy and selfish ambition, there you find disorder and every evil practice.” - James 3:16',
      ],
      'Embarrassment': [
        '“For God has not given us a spirit of fear, but of power and of love and of a sound mind.” - 2 Timothy 1:7',
        '“I can do all things through Christ who strengthens me.” - Philippians 4:13',
      ],
      'Ennui': [
        '“Whatever your hand finds to do, do it with all your might.” - Ecclesiastes 9:10',
        '“Delight yourself in the Lord, and He will give you the desires of your heart.” - Psalm 37:4',
      ],
      'Nostalgia': [
        '“Remember the days of old; consider the years of many generations.” - Deuteronomy 32:7',
        '“Forget not all His benefits.” - Psalm 103:2',
      ],
      'Disgust': [
        '“And He said, What comes out of a person is what defiles him.” - Mark 7:20',
        '“Do not be deceived: “Bad company ruins good morals.” - 1 Corinthians 15:33',
        '“For everything created by God is good, and nothing is to be rejected if it is received with thanksgiving.” - 1 Timothy 4:4',
        '“Keep your heart with all vigilance, for from it flow the springs of life.” - Proverbs 4:23',
      ],
    };

    // Get the list of verses for the selected mood
    final verses =
        gospelVerses[moodType] ?? ['No verse available for this mood.'];

    // Randomly select a verse from the list
    final randomVerse = verses[Random().nextInt(verses.length)];

    return Scaffold(
      appBar: AppBar(
        title: Text('$moodType Mood Verse'),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 8,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/calm4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay for better readability
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Centered text content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    moodType,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black45,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    randomVerse,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          blurRadius: 8.0,
                          color: Colors.black38,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Action for sharing the verse
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('Share This Verse'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Back to Moods'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
