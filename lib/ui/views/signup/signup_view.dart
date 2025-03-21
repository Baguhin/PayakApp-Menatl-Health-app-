import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tangullo/ui/views/signup/signup_viewmodel.dart';
import 'package:tangullo/ui/views/login/login_view.dart';

class SignupView extends StatelessWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ViewModelBuilder<SignupViewModel>.reactive(
      viewModelBuilder: () => SignupViewModel(),
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.lightBlue[50],
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.size.width * 0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo Icon
                      // App Logo
                      Image.asset(
                        'assets/images/logo.png',
                        height: 120, // Slightly bigger logo for emphasis
                        width: 120,
                      ),
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        'Create Your Account',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        'Join PayakApp for a guided mental wellness journey',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Signup Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Full Name
                            TextField(
                              onChanged: (value) => model.username = value,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: const Icon(Icons.person,
                                    color: Colors.teal),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Email / Mobile
                            TextField(
                              onChanged: (value) => model.email = value,
                              decoration: InputDecoration(
                                labelText: 'E-mail or Mobile Number',
                                prefixIcon:
                                    const Icon(Icons.email, color: Colors.teal),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Password
                            TextField(
                              onChanged: (value) => model.password = value,
                              obscureText: !model.showPassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon:
                                    const Icon(Icons.lock, color: Colors.teal),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    model.showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.black54,
                                  ),
                                  onPressed: model.togglePasswordVisibility,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Terms & Conditions
                            const Text(
                              'By signing up, you agree to our Terms & Conditions and Privacy Policy',
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),

                            // Sign Up Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: model.isBusy
                                    ? null
                                    : () => model.signup(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: model.isBusy
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Sign In Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account? ",
                                  style: TextStyle(fontSize: 16),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginView(
                                          title: '',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: mediaQuery.size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
