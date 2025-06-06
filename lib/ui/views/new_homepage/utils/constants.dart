import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  //colors
  static const kPrimaryColor = Color(0xFFFFFFFF);
  static const kGreyColor = Color(0xFFEEEEEE);
  static const kBlackColor = Color(0xFF000000);
  static const kDarkGreyColor = Color(0xFF9E9E9E);
  static const kDarkBlueColor = Color(0xFF6057FF);
  static const kBorderColor = Color(0xFFEFEFEF);
//colors

  static const Color primary = Color(0xFF4FC3F7);
  static const Color secondary = Color(0xFFF06292);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color blueGrey = Colors.blueGrey;

//padding

  static const double appPadding = 20.0;
  //text
  static const title = "Google Sign In";
  static const textIntro = "Mental Health \n";
  static const textIntroDesc1 = "Self-care is how you take your power back";
  static const textSmallSignUp = "Sign up takes only 2 minutes!";
  static const textSignIn = "Sign In";
  static const textStart = "Get Started";
  static const textSignInTitle = "Welcome back!";
  static const textSmallSignIn = "You've been missed";
  static const textSignInGoogle = "Sign In With Google";
  static const textAcc = "Don't have an account? ";
  static const textSignUp = "Sign Up here";
  static const textHome = "Home";
  static const signUp = "Sign Up ";
  static const textSignUpGoogle = "Sign up with Google";

  //navigate
  static const signInNavigate = '/sign-in';
  static const signUpNavigate = '/sign-up';
  static const homeNavigate = '/home';
  static const homerNavigate = '/new-home';

  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.kPrimaryColor,
      statusBarIconBrightness: Brightness.dark);
}