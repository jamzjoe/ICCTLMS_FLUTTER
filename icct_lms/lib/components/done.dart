import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Done extends StatelessWidget {
  const Done(
      {Key? key,
      required this.doneText,
      required this.score,
      required this.quizName})
      : super(key: key);
  final String doneText;
  final String score;
  final String quizName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/done.json', width: 200, repeat: true),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doneText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Quiz name: $quizName'),
                    Text('Score: $score')
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Done'))
          ],
        ),
      ),
    );
  }
}
