import 'package:flutter/material.dart';

class Member extends StatefulWidget {
  const Member({Key? key, required this.uid, required this.userType, required this.userName, required this.roomType}) : super(key: key);
  final String uid;
  final String userType;
  final String userName;
  final String roomType;
  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
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
