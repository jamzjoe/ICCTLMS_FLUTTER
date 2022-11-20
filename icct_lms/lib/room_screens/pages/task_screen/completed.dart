import 'package:flutter/material.dart';

class TaskCompleted extends StatefulWidget {
  const TaskCompleted({Key? key}) : super(key: key);

  @override
  State<TaskCompleted> createState() => _TaskCompletedState();
}

class _TaskCompletedState extends State<TaskCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Completed Task'),
      ),
    );
  }
}
