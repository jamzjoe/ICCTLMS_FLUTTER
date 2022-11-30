import 'package:flutter/material.dart';

class Grades extends StatefulWidget {
  const Grades({Key? key, required this.roomID}) : super(key: key);
  final String roomID;
  @override
  State<Grades> createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Grades'),
      ),
    );
  }
}
