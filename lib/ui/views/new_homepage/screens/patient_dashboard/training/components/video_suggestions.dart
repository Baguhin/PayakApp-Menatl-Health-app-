import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imagesList = [
  'assets/images/yoga1.jpg',
  'assets/images/yoga2.jpg',
  'assets/images/yoga3.jpg',
  'assets/images/yoga4.jpg',
];

class VideoSuggestions extends StatefulWidget {
  const VideoSuggestions({Key? key}) : super(key: key);

  @override
  _VideoSuggestionsState createState() => _VideoSuggestionsState();
}

class _VideoSuggestionsState extends State<VideoSuggestions> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            height: 170,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: imagesList
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      // Change from network to asset
                      item,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imagesList.map((urlOfItem) {
            int index = imagesList.indexOf(urlOfItem);
            return Container(
              width: 10.0,
              height: 10.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Colors.black
                    : Colors.black.withOpacity(0.3),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
