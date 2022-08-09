import 'package:flutter/material.dart';

class Answers extends StatelessWidget {
  const Answers({Key? key, required this.choices, required this.answered})
      : super(key: key);
  final String choices;
  final VoidCallback answered;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        onPressed: answered,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            choices,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.8)),
          ),
        ),
      ),
    );
  }
}
