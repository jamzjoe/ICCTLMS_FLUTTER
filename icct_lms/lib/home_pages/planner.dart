import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NoData(noDataText: 'No planner yet...',),
    );
  }
}
