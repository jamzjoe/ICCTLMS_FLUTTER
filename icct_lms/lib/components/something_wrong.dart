import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SomethingWrong extends StatelessWidget {
  const SomethingWrong({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Lottie.asset('assets/something_wrong.json', width: 200)],
      ),
    );
  }
}
