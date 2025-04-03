import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:tangullo/ui/views/models.dart';

import 'package:tangullo/ui/views/providers/providers.dart';
import 'package:tangullo/ui/views/utility/utilsss.dart';
import 'package:tangullo/ui/views/widgetsss/calories_card.dart';
import 'package:tangullo/ui/views/widgetsss/graph_card.dart';
import 'package:tangullo/ui/views/widgetsss/steps_card.dart';

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  String _status = 'stopped';
  String _steps = '0';

  @override
  void initState() {
    super.initState();
    debugPrint('StepCounterScreenState: initState');
    _initPlatformState();
  }

  /// Initializes the pedometer streams and requests permissions.
  Future<void> _initPlatformState() async {
    if (await Permission.activityRecognition.request().isGranted) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _stepCountStream = Pedometer.stepCountStream;

      _pedestrianStatusStream
          ?.listen(_onPedestrianStatusChanged)
          .onError(_onPedestrianStatusError);
      _stepCountStream?.listen(_onStepCount).onError(_onStepCountError);
    } else {
      debugPrint("Permission denied for activity recognition.");
      setState(() {
        _status = 'Permission Denied';
        _steps = 'N/A';
      });
    }
  }

  /// Handles step count updates.
  void _onStepCount(StepCount event) {
    debugPrint('StepCount Event: $event');
    Provider.of<StepCounterProvider>(context, listen: false).addSteps(
      formatDateForProvider(DateTime.now()),
      event.steps,
    );
    setState(() {
      _steps = event.steps.toString();
    });
  }

  /// Handles pedestrian status updates.
  void _onPedestrianStatusChanged(PedestrianStatus event) {
    debugPrint('Pedestrian Status: ${event.status}');
    setState(() {
      _status = event.status;
    });
  }

  /// Handles pedestrian status errors.
  void _onPedestrianStatusError(error) {
    debugPrint('Pedestrian Status Error: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  /// Handles step count errors.
  void _onStepCountError(error) {
    debugPrint('Step Count Error: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Counter'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                /// Step Counter and Calories UI
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: cardWidth + 80,
                        width: cardWidth,
                        child: StepsCard(status: _status),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: cardWidth + 80,
                        width: cardWidth,
                        child: const CaloriesCard(),
                      ),
                    ),
                  ],
                ),

                /// Graph Displaying Step Data
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HealthChart(stepCounts: [
                    StepCountData(0, 1000),
                    StepCountData(1, 2000),
                    StepCountData(2, 3000),
                    StepCountData(3, 4000),
                    StepCountData(4, 5000),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
