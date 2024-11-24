import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tangullo/ui/views/signup/signup_viewmodel.dart';
import 'package:tangullo/ui/views/login/login_view.dart'; // Ensure this import is added

class SignupView extends StatelessWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupViewModel>.reactive(
      viewModelBuilder: () => SignupViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.lightBlue[50], // Matching background color
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: MediaQuery.of(context).size.height *
                      0.1), // Responsive padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image at the top
                  Image.asset(
                    'assets/img/c3.png', // Update with your image path
                    height: 150, // Set an appropriate height
                    fit: BoxFit.contain, // Adjust the fit
                  ),

                  const SizedBox(height: 20),

                  // Signup Header
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  // Terms and Privacy Policy
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'By signing up you are agreeing to our\nTerms and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Username Text Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon:
                          const Icon(Icons.person, color: Colors.indigo),
                      labelStyle: const TextStyle(color: Colors.indigo),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      model.username = value;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Email Text Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email, color: Colors.indigo),
                      labelStyle: const TextStyle(color: Colors.indigo),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      model.email = value;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password Text Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.indigo),
                      suffixIcon: IconButton(
                        icon: Icon(
                          model.showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.indigo,
                        ),
                        onPressed: () {
                          model.togglePasswordVisibility();
                        },
                      ),
                      labelStyle: const TextStyle(color: Colors.indigo),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: !model.showPassword,
                    onChanged: (value) {
                      model.password = value;
                    },
                  ),

                  const SizedBox(height: 30),

                  // Sign-up Button
                  ElevatedButton(
                    onPressed: () {
                      model.signup(context); // Pass the context here
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.indigo, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: model.isBusy
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  Colors.white, // Changed text color to white
                            ),
                          ),
                  ),

                  const SizedBox(height: 30),

                  // Or connect with
                  const Center(
                    child: Text(
                      'Or connect with',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Social Media Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(
                            'assets/icons/facebook.png'), // Facebook icon
                        onPressed: () {
                          // Handle Facebook signup
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                            'assets/icons/instagram.png'), // Instagram icon
                        onPressed: () {
                          // Handle Instagram signup
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                            'assets/icons/pinterest.png'), // Pinterest icon
                        onPressed: () {
                          // Handle Pinterest signup
                        },
                      ),
                      IconButton(
                        icon: Image.asset(
                            'assets/icons/linkedin.png'), // LinkedIn icon
                        onPressed: () {
                          // Handle LinkedIn signup
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Login Text with custom slide transition
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const LoginView(
                            title: '',
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(
                                1.0, 0.0); // Start off the screen to the right
                            const end = Offset
                                .zero; // End at the original position (center of the screen)
                            const curve = Curves
                                .easeInOut; // The easing curve for the transition

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                                position: offsetAnimation,
                                child: child); // Slide transition
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
