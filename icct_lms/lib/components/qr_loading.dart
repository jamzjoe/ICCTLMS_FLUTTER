import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class QRloading extends StatefulWidget {
  const QRloading({Key? key, required this.loadingText}) : super(key: key);
  final String loadingText;

  @override
  State<QRloading> createState() => _QRloadingState();
}

class _QRloadingState extends State<QRloading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/qr.json', width: 200),
            Text(widget.loadingText)
          ],
        ),
      ),
    );
  }
}
