import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  const Post({Key? key, required this.uid, required this.userType, required this.userName, required this.roomType}) : super(key: key);
  final String uid;
  final String userType;
  final String userName;
  final String roomType;
  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(widget.roomType),
            Text(widget.uid),
            Text(widget.userType),
            Text(widget.userName)
          ],
        ),
      ),
    );
  }
}
