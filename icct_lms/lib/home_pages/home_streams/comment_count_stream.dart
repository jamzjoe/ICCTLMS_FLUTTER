import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/comment_room/comment.dart';
import 'package:icct_lms/home_pages/home.dart';
import 'package:icct_lms/models/post_model.dart';

class HomeCommentCountStreams extends StatelessWidget {
  const HomeCommentCountStreams(
      {Key? key, required this.widget, required this.e})
      : super(key: key);
  final HomeScreen widget;
  final PostModel e;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Post')
            .doc(e.postID)
            .collection('Comment')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final commentCount = snapshot.data!.docs.length;
            return Flexible(
                child: Row(
              children: [
                IconButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Comment(
                                  e: e,
                                  username: widget.userName,
                                  userType: widget.userType,
                                  userID: widget.uid)));
                    },
                    icon: const Icon(FontAwesomeIcons.solidComment,
                        color: Colors.grey)),
                Text(commentCount.toString())
              ],
            ));
          }
          return Flexible(
              child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FontAwesomeIcons.comment,
                    color: Colors.grey.withOpacity(0.4),
                  )),
              const Text('0')
            ],
          ));
        });
  }
}
