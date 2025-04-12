import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late List<CameraDescription> cameras;
  File? selectedImage;
  bool isProcessing = false;
  String? emotionResult = "Neutral";
  double? confidence = 0.0;
  final ImagePicker _picker = ImagePicker();
  String? geminiContent;
  bool isLoadingContent = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool apiError = false;

  // Server endpoint
  final String apiUrl =
      'https://legit-backend-iqvk.onrender.com/api/gemini/content';

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
    loadModel();
    initializeCamera();

    // Setup animation for content transition
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
    } catch (e) {
      developer.log('Error initializing camera: $e');
    }
  }

  Future<void> loadModel() async {
    try {
      interpreter =
          await Interpreter.fromAsset('assets/tflite_for_live/model.tflite');
      developer.log('Model loaded successfully');

      // Print the input tensor shape to understand what the model expects
      final inputShape = interpreter!.getInputTensor(0).shape;
      developer.log('Model input shape: $inputShape');
    } catch (e) {
      developer.log('Error loading model: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load emotion detection model: $e')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
          isProcessing = true;
          geminiContent = null; // Reset previous content
          apiError = false;
        });

        // Process the image
        await processImage(selectedImage!);

        // After processing, fetch content from Gemini
        await fetchGeminiContent();

        setState(() {
          isProcessing = false;
        });
      }
    } catch (e) {
      developer.log('Error picking image: $e');
      setState(() {
        isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing image: $e')),
      );
    }
  }

  Future<void> processImage(File imageFile) async {
    if (interpreter == null) {
      setState(() {
        emotionResult = "Neutral"; // Default if model isn't loaded
        confidence = 0.5;
      });
      return;
    }

    try {
      // Read the image file
      final imageBytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        developer.log('Failed to decode image');
        return;
      }

      // Resize the image to the required input size of the model (48x48)
      final resizedImage = img.copyResize(originalImage, width: 48, height: 48);

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
          developer.log(
              'Detected emotion: $emotionResult with confidence: $confidence');
        }
      });
    } catch (e) {
      developer.log('Error processing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error analyzing emotion: $e')),
      );
    }
  }

  Future<void> fetchGeminiContent() async {
    if (emotionResult == null) return;

    setState(() {
      isLoadingContent = true;
      apiError = false;
    });

    try {
      developer.log('Fetching Gemini content for emotion: $emotionResult');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'emotion': emotionResult,
        }),
      );

      developer.log('API Response status code: ${response.statusCode}');
      developer.log(
          'API Response body: ${response.body.substring(0, min(100, response.body.length))}...');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          geminiContent = data['content'];
          isLoadingContent = false;
          _animationController.reset();
          _animationController.forward();
        });
      } else {
        developer.log('API error: ${response.statusCode} - ${response.body}');
        setState(() {
          geminiContent = "Couldn't fetch content. Try again later.";
          isLoadingContent = false;
          apiError = true;
        });
      }
    } catch (e) {
      developer.log('Error fetching Gemini content: $e');
      setState(() {
        geminiContent = "Network error while getting content.";
        isLoadingContent = false;
        apiError = true;
      });
    }
  }

  // Function to retry fetching content
  void retryFetchContent() {
    if (emotionResult != null) {
      fetchGeminiContent();
    }
  }

  int min(int a, int b) => a < b ? a : b;

  // Get appropriate emotion theme based on detected emotion
  Map<String, dynamic> _getEmotionTheme() {
    switch (emotionResult) {
      case 'Angry':
        return {
          'color': Colors.red.shade700,
          'gradient': [Colors.red.shade600, Colors.red.shade900],
          'icon': Icons.mood_bad,
          'title': "Here's a joke to cheer you up!"
        };
      case 'Fear':
        return {
          'color': Colors.purple.shade700,
          'gradient': [Colors.purple.shade600, Colors.purple.shade900],
          'icon': Icons.sentiment_very_dissatisfied,
          'title': "Some reassuring thoughts:"
        };
      case 'Happy':
        return {
          'color': Colors.amber.shade700,
          'gradient': [Colors.amber.shade600, Colors.amber.shade800],
          'icon': Icons.sentiment_very_satisfied,
          'title': "Keep the good vibes going!"
        };
      case 'Neutral':
        return {
          'color': Colors.blue.shade700,
          'gradient': [Colors.blue.shade600, Colors.blue.shade900],
          'icon': Icons.sentiment_neutral,
          'title': "Interesting fact for you:"
        };
      case 'Sad':
        return {
          'color': Colors.indigo.shade700,
          'gradient': [Colors.indigo.shade600, Colors.indigo.shade900],
          'icon': Icons.sentiment_dissatisfied,
          'title': "Something to brighten your day:"
        };
      case 'Surprised':
        return {
          'color': Colors.orange.shade700,
          'gradient': [Colors.orange.shade600, Colors.orange.shade900],
          'icon': Icons.sentiment_very_satisfied,
          'title': "More surprising facts:"
        };
      default:
        return {
          'color': Colors.grey.shade700,
          'gradient': [Colors.grey.shade600, Colors.grey.shade900],
          'icon': Icons.face,
          'title': "Hmm, interesting..."
        };
    }
  }

  Widget _buildEmotionCard() {
    final theme = _getEmotionTheme();
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 10,
      shadowColor: theme['color'].withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight:
              screenHeight * 0.75, // 👈 Limits card to 75% of screen height
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme['gradient'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            // 👈 add this scroll view around Column
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        theme['icon'],
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      emotionResult ?? 'No emotion',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // confidence indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    'Confidence: ${((confidence ?? 0) * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),

                const Divider(color: Colors.white38, thickness: 1, height: 24),

                // card title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    theme['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Content section
                Container(
                  constraints: BoxConstraints(
                    maxHeight:
                        screenHeight * 0.4, // 👈 40% of screen for content area
                  ),
                  child: isLoadingContent
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Getting personalized content...",
                                style: TextStyle(color: Colors.white70),
                              )
                            ],
                          ),
                        )
                      : FadeTransition(
                          opacity: _animation,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.05),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Text(
                                      geminiContent ?? "Loading content...",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (apiError) ...[
                                      const SizedBox(height: 16),
                                      ElevatedButton.icon(
                                        onPressed: retryFetchContent,
                                        icon: const Icon(Icons.refresh),
                                        label: const Text("Retry"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white24,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade900,
              Colors.indigo.shade900
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emotion Detector',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Discover how you feel',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Image Container
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: selectedImage == null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.shade50,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.deepPurple.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    size: 80,
                                    color: Colors.deepPurple.shade300,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Take or select a photo\nto detect your emotion',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(16),
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Text(
                                    'We\'ll analyze your expression!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                              if (isProcessing)
                                Container(
                                  color: Colors.black54,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 3,
                                          backgroundColor: Colors.black26,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          'Analyzing your emotion...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),

              // Results Panel
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Expanded(
                        child: selectedImage == null
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.mood,
                                        size: 50,
                                        color: Colors.deepPurple.shade200,
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Take a photo to see\nwhat we say about your emotion!',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: _buildEmotionCard(),
                              ),
                      ),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple.shade100,
                                foregroundColor: Colors.deepPurple.shade800,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library),
                              label: const Text(
                                'Gallery',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple.shade700,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text(
                                'Camera',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
