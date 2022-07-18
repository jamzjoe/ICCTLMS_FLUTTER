import 'package:flutter/material.dart';
import 'package:icct_lms/home_pages/edit_profile.dart';
import 'package:icct_lms/pages/choose_type_user.dart';
import 'package:icct_lms/pages/forgot_password.dart';
import 'package:icct_lms/pages/home.dart';
import 'package:icct_lms/pages/intro_slider.dart';
import 'package:icct_lms/pages/login.dart';
import 'package:icct_lms/pages/parent.dart';
import 'package:icct_lms/pages/register.dart';
import 'package:icct_lms/pages/splash_screen.dart';
void main() {
  runApp(MaterialApp(
initialRoute: '/',
routes: {
  '/': (context) => const SplashScreen(),
  '/intro': (context) => const IntroSlider(),
  '/home': (context) => const Home(),
  '/choose_user': (context) => const ChooseUser(),
  '/user_login': (context) => const Login(),
  '/user_register': (context) => const Register(),
  '/parent': (context) => const Parent(),
  '/forgot_password': (context) => const ForgotPassword(),
},
  ));
}
