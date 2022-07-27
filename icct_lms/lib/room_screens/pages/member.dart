import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';

class Member extends StatefulWidget {
  const Member(
      {Key? key,
      required this.uid,
      required this.userType,
      required this.userName,
      required this.roomType})
      : super(key: key);
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            const Text(
              'Members',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ), Expanded(
              child: ListView(
                children: [
                  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  IntrinsicHeight(child: Center(child: NoData())),
                ],
              )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
