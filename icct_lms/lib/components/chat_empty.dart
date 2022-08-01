import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatLoad extends StatelessWidget {
  const ChatLoad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/chat.json', width: 200),
            const Text('No messages yet...')
          ],
        ),
      );
  }
}
