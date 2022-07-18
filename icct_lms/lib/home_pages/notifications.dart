import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen( {Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Notifications'),
            Text(widget.uid)
          ],
        ),
      ),
    );
  }
}
