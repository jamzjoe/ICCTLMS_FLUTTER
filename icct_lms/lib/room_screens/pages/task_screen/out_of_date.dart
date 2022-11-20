import 'package:flutter/material.dart';

class OutOfDateTask extends StatefulWidget {
  const OutOfDateTask({Key? key}) : super(key: key);

  @override
  State<OutOfDateTask> createState() => _OutOfDateTaskState();
}

class _OutOfDateTaskState extends State<OutOfDateTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Out of Date Task'),
      ),
    );
  }
}
