import 'package:flutter/material.dart';

class Choices extends StatelessWidget {
  const Choices({Key? key, required this.answers})
      : super(key: key);
  final List<String> answers;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        onPressed: (){},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              builTiles(answers)
            ],
          )
        ),
      ),
    );
  }

  Widget builTiles(List options) => Card(
    child: Text(options[0]),
  );
}
