import 'package:flutter/material.dart';
import 'package:tangullo/ui/views/login/login_viewmodel.dart';
import 'package:tangullo/ui/views/signup/signup_view.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key, required String title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(context),
      builder: (context, model, child) {
        // Use MediaQuery to get the screen dimensions
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return Scaffold(
          backgroundColor: Colors.lightBlue[50], // Calming background color
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.1),

                  // Logo or Image (Optional)
                  Center(
                    child: Image.asset(
                      'assets/img/c2.png', // Add your logo image path
                      height: 125,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0),

                  // Login Header
                  const Center(
                    child: Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),
                  const Center(
                    child: Text(
                      'Log in to continue your journey',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.indigoAccent,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Terms and Privacy Policy
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'By logging in, you agree to our Terms and Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Tab to switch between Login and Register (optional)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            _createTransitionRoute(const SignupView()),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.indigoAccent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

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

                  SizedBox(height: screenHeight * 0.02),

                  // Password Text Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.indigo),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          // Toggle password visibility
                        },
                        child: const Icon(Icons.visibility_off,
                            color: Colors.indigo),
                      ),
                      labelStyle: const TextStyle(color: Colors.indigo),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      model.password = value;
                    },
                  ),

                  SizedBox(height: screenHeight * 0.01),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: model.rememberPassword,
                            onChanged: (value) {
                              model.rememberPassword = value ?? false;
                            },
                            activeColor: Colors.indigo,
                          ),
                          const Text('Remember password'),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle forgot password logic
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.indigo,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      model.login(model.email, model.password);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Or connect with
                  const Center(
                    child: Text(
                      'Or connect with',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Social Media Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.facebook, color: Colors.indigo),
                        onPressed: () {
                          // Handle Facebook login
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.g_translate, color: Colors.red),
                        onPressed: () {
                          // Handle Google login
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Motivational Message
                  const Center(
                    child: Text(
                      'You are not alone on this journey.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.indigo,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Custom transition for navigating to SignupView
  PageRouteBuilder _createTransitionRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide in from the right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
