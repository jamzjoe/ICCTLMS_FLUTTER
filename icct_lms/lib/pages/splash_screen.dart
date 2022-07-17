import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  void validateUser(){
     Future.delayed(const Duration(seconds: 4), (){Navigator.pushReplacementNamed(context, '/'
         'intro');
    });
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
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/logo_plain.png'),
            ),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text('Institute of Creative Computer Technology', style:
            TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14
            ),),
            ),
          SizedBox(height: 5,),
          Center(
            child: Text('Learning Management System', style:
            TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 10
            ),),
          ),
          SizedBox(height: 20,),
          Center(
            child: SpinKitFoldingCube(
              color: Colors.blueAccent,
            ),
          )
        ],
      ),
    );
  }
}
