import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen( {Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Padding(padding: EdgeInsets.all(20),
        child: const Text('Messages'),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animationDuration: const Duration(milliseconds: 500),
        children: [
          SpeedDialChild(
              child: const Icon(CupertinoIcons.chat_bubble_2_fill),
              label: 'New Message',
              labelBackgroundColor: Colors.yellow,
              backgroundColor: Colors.yellow),
        ],
      ),
    );
  }
}
