import 'package:flutter/material.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen( {Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Planner'),
            Text(widget.uid)
          ],
        ),
      ),
    );
  }
}
