import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class QRloading extends StatelessWidget {
  const QRloading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset('assets/qr.json', width: 200),
      ),
    );
  }
}
