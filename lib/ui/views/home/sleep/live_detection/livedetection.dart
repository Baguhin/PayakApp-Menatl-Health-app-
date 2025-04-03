import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as img;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  bool isDetecting = false;
  int selectedCameraIndex = 0; // 0 for back camera, 1 for front camera
  bool isCameraInitialized = false;
  String? emotionResult = "Neutral";
  double? confidence = 0.0;

  // TFLite model
  Interpreter? interpreter;
  List<String> labels = [
    "Angry",
    "Fear",
    "Happy",
    "Neutral",
    "Sad",
    "Surprised"
  ];

  @override
  void initState() {
    super.initState();
    initializeCamera();
    loadModel();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Camera Error'),
              content: const Text('No camera found on this device.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Start with the front camera for face detection
      selectedCameraIndex =
          cameras.length > 1 ? 1 : 0; // Front camera if available

      await startCamera(selectedCameraIndex);
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> startCamera(int cameraIndex) async {
    if (cameraController != null) {
      await cameraController!.dispose();
    }

    if (cameras.isEmpty) return;

    try {
      cameraController = CameraController(
        cameras[cameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();

      if (!mounted) return;

      cameraController!.startImageStream((CameraImage cameraImage) {
        if (!isDetecting) {
          isDetecting = true;
          runModelOnFrame(cameraImage);
        }
      });

      setState(() {});
    } catch (e) {
      print('Error starting camera: $e');
    }
  }

  Future<void> loadModel() async {
    try {
      interpreter =
          await Interpreter.fromAsset('assets/tflite_for_live/model.tflite');
      print('Model loaded successfully');

      // Print the input tensor shape to understand what the model expects
      final inputShape = interpreter!.getInputTensor(0).shape;
      print('Model input shape: $inputShape');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  // Function to preprocess the camera image
  img.Image? _convertYUV420ToImage(CameraImage cameraImage) {
    try {
      final width = cameraImage.width;
      final height = cameraImage.height;

      final yRowStride = cameraImage.planes[0].bytesPerRow;
      final uvRowStride = cameraImage.planes[1].bytesPerRow;
      final uvPixelStride = cameraImage.planes[1].bytesPerPixel ?? 1;

      final image = img.Image(width: width, height: height);

      for (var w = 0; w < width; w++) {
        for (var h = 0; h < height; h++) {
          final uvIndex = uvPixelStride * (w ~/ 2) + uvRowStride * (h ~/ 2);
          final index = h * width + w;
          final yIndex = h * yRowStride + w;

          final y = cameraImage.planes[0].bytes[yIndex];
          final u = cameraImage.planes[1].bytes[uvIndex];
          final v = cameraImage.planes[2].bytes[uvIndex];

          // Convert YUV to RGB
          var r = (y + 1.13983 * (v - 128));
          var g = (y - 0.39465 * (u - 128) - 0.58060 * (v - 128));
          var b = (y + 2.03211 * (u - 128));

          // Clipping RGB values to be inside boundaries [0, 255]
          r = r.clamp(0, 255);
          g = g.clamp(0, 255);
          b = b.clamp(0, 255);

          // Create the pixel with the RGB values
          final pixel = img.ColorRgb8(r.toInt(), g.toInt(), b.toInt());
          image.setPixel(w, h, pixel);
        }
      }

      return image;
    } catch (e) {
      print('Error converting YUV to image: $e');
      return null;
    }
  }

  // Function to resize the image
  img.Image resizeImage(img.Image image, int width, int height) {
    return img.copyResize(image, width: width, height: height);
  }

  Future<void> runModelOnFrame(CameraImage image) async {
    if (interpreter == null) {
      isDetecting = false;
      return;
    }

    try {
      // Convert camera image to regular image
      final convertedImage = _convertYUV420ToImage(image);
      if (convertedImage == null) {
        isDetecting = false;
        return;
      }

      // Resize the image to the required input size of the model (e.g., 48x48 for emotion detection)
      final resizedImage = resizeImage(convertedImage, 48, 48);

      // Prepare input data for the model (normalize to [0, 1])
      var inputData = List<List<List<double>>>.generate(
        48,
        (_) => List<List<double>>.generate(
          48,
          (_) => List<double>.generate(3, (_) => 0),
        ),
      );

      for (var y = 0; y < 48; y++) {
        for (var x = 0; x < 48; x++) {
          // Get the pixel RGB values
          final pixel = resizedImage.getPixel(x, y);
          // Extract RGB values and normalize to [0, 1]
          final r = pixel.r.toDouble() / 255.0;
          final g = pixel.g.toDouble() / 255.0;
          final b = pixel.b.toDouble() / 255.0;

          // Assign to input tensor
          inputData[y][x][0] = r;
          inputData[y][x][1] = g;
          inputData[y][x][2] = b;
        }
      }

      // Reshape input to match model's input shape
      var input = [inputData];

      // Prepare output tensor
      var output =
          List<double>.filled(labels.length, 0).reshape([1, labels.length]);

      // Run inference
      interpreter!.run(input, output);

      // Process the output
      var results = output[0] as List<double>;

      // Find the index with the highest confidence
      int maxIndex = 0;
      double maxConfidence = results[0];

      for (var i = 0; i < results.length; i++) {
        if (results[i] > maxConfidence) {
          maxConfidence = results[i];
          maxIndex = i;
        }
      }

      // Update state with results
      setState(() {
        if (maxIndex < labels.length) {
          emotionResult = labels[maxIndex];
          confidence = maxConfidence;
        }
      });

      isDetecting = false;
    } catch (e) {
      print('Error running model: $e');
      isDetecting = false;
    }
  }

  void switchCamera() async {
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    await startCamera(selectedCameraIndex);
  }

  @override
  void dispose() {
    // Stop image stream before disposing
    cameraController?.stopImageStream();
    cameraController?.dispose();

    // Safely close interpreter
    interpreter?.close();

    super.dispose();
  }

  Widget _buildEmotionCard() {
    Color cardColor;
    IconData emotionIcon;

    switch (emotionResult) {
      case 'Angry':
        cardColor = Colors.red;
        emotionIcon = Icons.mood_bad;
        break;
      case 'Fear':
        cardColor = Colors.purple;
        emotionIcon = Icons.sentiment_very_dissatisfied;
        break;
      case 'Happy':
        cardColor = Colors.amber;
        emotionIcon = Icons.sentiment_very_satisfied;
        break;
      case 'Neutral':
        cardColor = Colors.blue;
        emotionIcon = Icons.sentiment_neutral;
        break;
      case 'Sad':
        cardColor = Colors.indigo;
        emotionIcon = Icons.sentiment_dissatisfied;
        break;
      case 'Surprised':
        cardColor = Colors.orange;
        emotionIcon = Icons.sentiment_very_satisfied;
        break;
      default:
        cardColor = Colors.grey;
        emotionIcon = Icons.face;
    }

    return Card(
      color: cardColor,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              emotionIcon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              emotionResult ?? 'Detecting...',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Confidence: ${((confidence ?? 0) * 100).toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized ||
        cameraController == null ||
        !cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Emotion Detection'),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: switchCamera,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CameraPreview(cameraController!),
                ),
                if (isDetecting)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Detecting...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Detected Emotion',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildEmotionCard(),
                  const SizedBox(height: 10),
                  const Text(
                    'Keep your face centered for best results',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
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
