import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/room_screens/pages/write_post.dart';

class Post extends StatefulWidget {
  const Post(
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
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(widget.userName.substring(0, 2).toUpperCase()),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextField(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WritePost(
                              uid: widget.uid,
                              userType: widget.userType,
                              roomType: widget.userType,
                              userName: widget.userName,
                            ))),
                readOnly: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "What's on your mind?"),
              ))
            ],
          ),
          const NoData()
        ],
      ),
    ));
  }
}
