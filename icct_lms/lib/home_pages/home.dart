import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Home'),
            Text(widget.uid)
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        overlayColor: Colors.black54,
        backgroundColor: Colors.blue[900],
        animatedIcon: AnimatedIcons.menu_close,
        animationDuration: const Duration(milliseconds: 300),
        children: [
          SpeedDialChild(
              child: const Icon(CupertinoIcons.create),
              label: 'Post',
              labelBackgroundColor: Colors.yellow,
              backgroundColor: Colors.yellow),
          SpeedDialChild(
              child: const Icon(CupertinoIcons.chat_bubble),
              label: 'Message',
              labelBackgroundColor: Colors.yellow,
              backgroundColor: Colors.yellow)
        ],
      ),
    );
  }
}
