import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icct_lms/bloc/quiz/quiz_bloc.dart';
import 'package:icct_lms/models/user_model.dart';
import 'package:icct_lms/pages/forgot_password.dart';
import 'package:icct_lms/pages/intro_slider.dart';
import 'package:icct_lms/services/auth.dart';
import 'package:icct_lms/services/notification_service.dart';
import 'package:icct_lms/wrapper/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  FlutterNativeSplash.removeAfter(initialize);
  runApp(MyApp(
    showHome: showHome,
  ));
}



Future initialize(BuildContext? context) async {
  await Future.delayed(const Duration(seconds: 0));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.showHome,
  });
  final bool showHome;
  @override
  State<MyApp> createState() => _MyAppState();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
class _MyAppState extends State<MyApp> {
@override
  void initState() {
    NotificationService.initialize(flutterLocalNotificationsPlugin);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      value: AuthService().user,
      catchError: (_, __) => null,
      initialData: null,
      child: BlocProvider<QuizBloc>(
        create: (_) => QuizBloc(),
        child: MaterialApp(

          theme: ThemeData(
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
          routes: {
            '/wrap': (_) => const Wrapper(),
            '/forgot_password': (_) => const ForgotPassword()
          },
          title: 'ICCT LMS',
          home: widget.showHome ? const Wrapper() : const IntroSlider(),
        ),
      ),
    );
  }
}

