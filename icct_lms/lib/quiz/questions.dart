import 'package:flutter/material.dart';

class Questions extends StatefulWidget {
  const Questions(
      {Key? key, required this.questions, required this.questionNumber})
      : super(key: key);
  final String questions;
  final int questionNumber;
  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.questionNumber}. ${widget.questions}',
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
    );
  }
}
