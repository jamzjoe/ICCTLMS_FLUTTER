import 'package:flutter/material.dart';

class ScoreDisplay extends StatefulWidget {
  const ScoreDisplay({Key? key, required this.score, required this.total})
      : super(key: key);
  final String score;
  final String total;
  @override
  State<ScoreDisplay> createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Your Score is: ${widget.score}/${widget.total}'),
            ElevatedButton(
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
