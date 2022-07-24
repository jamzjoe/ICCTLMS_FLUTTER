import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:icct_lms/components/nodata.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const NoData(),
      floatingActionButton: SpeedDial(
        spaceBetweenChildren: 10,
        overlayColor: Colors.black54,
        backgroundColor: Colors.blue[900],
        animatedIcon: AnimatedIcons.menu_close,
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
