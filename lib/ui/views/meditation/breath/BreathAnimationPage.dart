// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';

class BreathAnimationPage extends StatefulWidget {
  final String breathingName;
  final int duration; // Total duration of the breathing exercise in seconds

  const BreathAnimationPage({
    Key? key,
    required this.breathingName,
    required this.duration,
  }) : super(key: key);

  @override
  _BreathAnimationPageState createState() => _BreathAnimationPageState();
}

class _BreathAnimationPageState extends State<BreathAnimationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int remainingTime; // Remaining time for the exercise
  bool _isPaused = false; // To track pause state

  @override
  void initState() {
    super.initState();
    remainingTime = widget.duration; // Set remaining time

    // Initialize the animation controller
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    // Create the animation
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the breathing animation and timer
    _startBreathingAnimation();
    _startTimer();
  }

  void _startBreathingAnimation() {
    // Play the animation forward and then reverse
    _controller.forward().whenComplete(() {
      _controller.reverse().whenComplete(() {
        if (remainingTime > 0 && !_isPaused) {
          _startBreathingAnimation(); // Repeat animation if not paused
        }
      });
    });
  }

  void _startTimer() {
    if (!_isPaused) {
      Future.delayed(const Duration(seconds: 1), () {
        if (remainingTime > 0) {
          setState(() {
            remainingTime--;
          });
          _startTimer(); // Continue the timer
        } else {
          // Navigate back after the duration
          _controller.stop();
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getBreathingPhase() {
    return _controller.isAnimating
        ? (_controller.value < 0.5 ? "Breathe In" : "Breathe Out")
        : "Breathe In";
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _controller.stop(); // Stop the animation
      } else {
        _startBreathingAnimation(); // Resume animation
        _startTimer(); // Resume timer
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int minutes = (remainingTime / 60).floor();
    int seconds = (remainingTime % 60).floor();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.breathingName),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _togglePause,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF007991), Color(0xFF78ffd6), Color(0xFF007991)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.tealAccent,
                            Colors.transparent,
                          ],
                          center: Alignment.center,
                          radius: 0.6,
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 10,
                          ),
                        ],
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF007991),
                            Color(0xFF78ffd6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          getBreathingPhase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black26,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: remainingTime / widget.duration,
                      strokeWidth: 8,
                      backgroundColor: Colors.tealAccent,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Remaining Time: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Follow along with the breathing pattern',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
