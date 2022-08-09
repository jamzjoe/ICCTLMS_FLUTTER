import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:icct_lms/home_pages/post_streams/joinedClassStreams.dart';
import 'package:icct_lms/home_pages/post_streams/joinedGroupStreams.dart';
import 'package:icct_lms/home_pages/post_streams/postGroupStreams.dart';
import 'package:icct_lms/home_pages/post_streams/postStreams.dart';
import 'package:icct_lms/services/comment.dart';
import 'package:share_plus/share_plus.dart';

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

final CommentService service = CommentService();

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(seconds: 1),
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 0,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blue[900],
            indicatorWeight: 2,
            tabs: const [
              Tab(
                text: 'Class Posts',
              ),
              Tab(
                text: 'Group Posts',
              ),
            ],
          ),
        ),
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
        body: TabBarView(children: [
          widget.userType == "Student"
              ? JoinedStreams(widget: widget, context: context)
              : PostStreams(widget: widget),
          widget.userType == "Student"
              ? JoinedGroupStreams(widget: widget, context: context)
              : PostGroupStreams(widget: widget),
        ]),
      ),
    );
  }

  Future share(String message, String name) async {
    await Share.share('Post from $name \n $message');
  }
}
