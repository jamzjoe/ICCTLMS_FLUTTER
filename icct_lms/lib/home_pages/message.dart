import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen( {Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Messages'),
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
              child: const Icon(CupertinoIcons.chat_bubble_2_fill),
              label: 'New Message',
              labelBackgroundColor: Colors.yellow,
              backgroundColor: Colors.yellow),
        ],
      ),
    );
  }
}
