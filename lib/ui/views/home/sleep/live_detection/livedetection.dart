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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load emotion detection model: $e')),
        );
      }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing image: $e')),
        );
      }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error analyzing emotion: $e')),
        );
      }
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
          'gradient': [Colors.red.shade500, Colors.red.shade900],
          'icon': Icons.mood_bad,
          'title': "Here's a joke to cheer you up!"
        };
      case 'Fear':
        return {
          'color': Colors.purple.shade700,
          'gradient': [Colors.purple.shade500, Colors.purple.shade900],
          'icon': Icons.sentiment_very_dissatisfied,
          'title': "Some reassuring thoughts:"
        };
      case 'Happy':
        return {
          'color': Colors.amber.shade700,
          'gradient': [Colors.amber.shade500, Colors.amber.shade800],
          'icon': Icons.sentiment_very_satisfied,
          'title': "Keep the good vibes going!"
        };
      case 'Neutral':
        return {
          'color': Colors.blue.shade700,
          'gradient': [Colors.blue.shade500, Colors.blue.shade900],
          'icon': Icons.sentiment_neutral,
          'title': "Interesting fact for you:"
        };
      case 'Sad':
        return {
          'color': Colors.indigo.shade700,
          'gradient': [Colors.indigo.shade500, Colors.indigo.shade900],
          'icon': Icons.sentiment_dissatisfied,
          'title': "Something to brighten your day:"
        };
      case 'Surprised':
        return {
          'color': Colors.orange.shade700,
          'gradient': [Colors.orange.shade500, Colors.orange.shade900],
          'icon': Icons.sentiment_very_satisfied,
          'title': "More surprising facts:"
        };
      default:
        return {
          'color': Colors.grey.shade700,
          'gradient': [Colors.grey.shade500, Colors.grey.shade900],
          'icon': Icons.face,
          'title': "Hmm, interesting..."
        };
    }
  }

  Widget _buildEmotionCard() {
    final theme = _getEmotionTheme();
    return Card(
      elevation: 8,
      shadowColor: theme['color'].withOpacity(0.5),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme['gradient'],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Header section with emotion info
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Emotion icon and label
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          theme['icon'],
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        emotionResult ?? 'No emotion',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Confidence badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white38, width: 1),
                    ),
                    child: Text(
                      '${((confidence ?? 0) * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white24, height: 1),

            // Content section
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  color: Colors.white.withOpacity(0.1),
                  width: double.infinity,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 12, 16, 8),
                                child: Text(
                                  theme['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              // Content area with scrolling
                              Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      children: [
                                        Text(
                                          geminiContent ?? "Loading content...",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            height: 1.5,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        if (apiError) ...[
                                          const SizedBox(height: 20),
                                          Center(
                                            child: ElevatedButton.icon(
                                              onPressed: retryFetchContent,
                                              icon: const Icon(Icons.refresh),
                                              label: const Text("Retry"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white24,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 12,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mood,
                size: 48,
                color: Colors.deepPurple.shade300,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Take a photo to see\nwhat we say about your mood!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
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
              Colors.deepPurple.shade700,
              Colors.deepPurple.shade900,
              Colors.indigo.shade900
            ],
          ),
        ),
        // Make the entire page scrollable instead of fixed height divisions
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                          size: 26,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Discover how you feel',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Image Container (with a fixed aspect ratio instead of Expanded)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  height: MediaQuery.of(context).size.width *
                      0.7, // Responsive height based on width
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
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
                                  ),
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    size: 64,
                                    color: Colors.deepPurple.shade300,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Take or select a photo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
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
                                    'We\'ll analyze your expression',
                                    style: TextStyle(
                                      fontSize: 13,
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
                                  child: const Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 3,
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Analyzing your emotion...',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10,
                                                color: Colors.black54,
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

                // Results Section - White background area
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Drag handle
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Results card - with fixed height instead of Expanded
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.4, // Fixed reasonable height
                          child: selectedImage == null
                              ? _buildPlaceholder()
                              : _buildEmotionCard(),
                        ),
                      ),

                      // Action buttons
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple.shade100,
                                  foregroundColor: Colors.deepPurple.shade800,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery),
                                icon: const Icon(Icons.photo_library, size: 22),
                                label: const Text(
                                  'Gallery',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple.shade600,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: () => _pickImage(ImageSource.camera),
                                icon: const Icon(Icons.camera_alt, size: 22),
                                label: const Text(
                                  'Camera',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
