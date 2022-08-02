import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key, required this.notFoundText}) : super(key: key);
  final String notFoundText;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/404.json', width: 200),
          Text(notFoundText,
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
