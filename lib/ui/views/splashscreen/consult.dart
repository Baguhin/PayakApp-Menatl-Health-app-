// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_size_text/auto_size_text.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;
  final _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  controller: _controller,
                  children: [
                    onBoardingStyle(
                      'assets/img/onBoarding1.json',
                      'Improve your Mental Health',
                      'Utilizing Natural Language Processing, we provide personalized mental health support through interactive conversations and insights.',
                    ),
                    onBoardingStyle(
                      'assets/img/onBoarding2.json',
                      'Online Consultations with Experts',
                      'Busy schedule? Get professional consultations right at your fingertips through PayakApp.',
                    ),
                    onBoardingStyle(
                      'assets/img/onBoarding3.json',
                      'Track Your Mental Health Progress',
                      'PayakApp empowers you to track your mental health Mood.',
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) {
                    return Container(
                      height: 10,
                      width: currentIndex == index ? 25 : 10,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 100),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    elevation: 15,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.fromLTRB(100, 15, 100, 15),
                  ),
                  onPressed: () {
                    if (currentIndex == 2) {
                      Navigator.pushNamed(context, '/login');
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(currentIndex == 2 ? 'Continue' : 'Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget onBoardingStyle(String animation, String title, String description) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          animation,
          height: screenHeight * 0.4, // Adjust animation size
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
            horizontal: screenWidth * 0.05,
          ),
          child: AutoSizeText(
            title,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.07,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
            horizontal: screenWidth * 0.05,
          ),
          child: AutoSizeText(
            description,
            maxLines: 4,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
