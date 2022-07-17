import 'package:flutter/material.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen( {Key? key}) : super(key: key);

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Text('Planner'),
      ),
    );
  }
}
