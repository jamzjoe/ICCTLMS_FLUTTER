import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icct_lms/pages/choose_type_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  void validateUser() async{
      final prefs = await SharedPreferences.getInstance();
      final showHome = prefs.getBool('showHome') ?? false;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>  ChooseUser()
      )
      );
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    validateUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Hero(
              tag: 'assets/logo_black_text.png',
              child: Image(
                width: 250,
                image: AssetImage('assets/logo_white_text.png'),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text('Institute of Creative Computer Technology', style:
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14
            ),),
            ),
          SizedBox(height: 5,),
          Center(
            child: Text('Learning Management System', style:
            TextStyle(
              color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 12
            ),),
          ),
          SizedBox(height: 100,),
          Center(
            child: SpinKitPouringHourGlassRefined(
              color: Colors.white,
              duration: Duration(seconds: 2),
            ),
          )
        ],
      ),
    );
  }
}

