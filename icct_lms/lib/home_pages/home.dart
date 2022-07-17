import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Home'),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animationDuration: const Duration(milliseconds: 500),
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
