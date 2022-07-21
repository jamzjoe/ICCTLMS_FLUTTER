import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
              Image(image: AssetImage('assets/logo_black_text.png'), width:
              200,),
             SpinKitFadingCircle(
              color: Colors.blue,
              size: 40,
            ),
          ],
        ),
      ),
    );
  }
}
