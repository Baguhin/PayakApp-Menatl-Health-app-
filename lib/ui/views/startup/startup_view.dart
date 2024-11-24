import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import '../navigation/homepage_view.dart';
import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset('assets/animation.json'),
          ),
          const SizedBox(
              height:
                  20), // Add some spacing between the animation and the text
          const Text(
            'PayakApp',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      nextScreen: const HomepageView(title: 'Welcome to PayakApp'), // Updated
      splashIconSize: 400,
      backgroundColor: Colors.green,
      duration: 5000,
    );
  }

  @override
  StartupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());

  @override
  Widget builder(
      BuildContext context, StartupViewModel viewModel, Widget? child) {
    throw UnimplementedError();
  }
}
