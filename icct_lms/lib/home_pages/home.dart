import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:icct_lms/components/nodata.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {Key? key,
      required this.uid,
      required this.userType,
      required this.userName,
      required this.userEmail,
      required this.userCampus})
      : super(key: key);
  final String uid;
  final String userType;
  final String userName;
  final String userEmail;
  final String userCampus;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const NoData(noDataText: 'No home yet...',),
      floatingActionButton: SpeedDial(
        overlayColor: Colors.black54,
        backgroundColor: Colors.blue[900],
        spaceBetweenChildren: 10,
        animatedIcon: AnimatedIcons.menu_close,
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
