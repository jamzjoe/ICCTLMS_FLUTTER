import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:icct_lms/models/user_model.dart';
import 'package:icct_lms/pages/intro_slider.dart';
import 'package:icct_lms/services/auth.dart';
import 'package:icct_lms/wrapper/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  FlutterNativeSplash.removeAfter(initialize);
  runApp(MyApp(showHome: showHome));
}

Future initialize(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 0));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.showHome});
  final bool showHome;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      catchError: (_, __) => null,
      initialData: null,
      child: MaterialApp(
        routes: {
          '/wrap': (context) => const Wrapper(),
        },
        title: 'ICCT LMS',
        home: widget.showHome ? const Wrapper() : const IntroSlider(),
      ),
    );
  }
}
