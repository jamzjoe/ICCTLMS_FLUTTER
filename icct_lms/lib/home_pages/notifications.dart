import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NoData(noDataText: 'No notifications yet...',),
    );
  }
}
