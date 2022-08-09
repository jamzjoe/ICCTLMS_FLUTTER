import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/comment_room/comment.dart';


class CommentCountStream extends StatelessWidget {
  const CommentCountStream({Key? key, required this.widget}) : super(key: key);
  final Comment widget;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Post')
            .doc(widget.e.postID)
            .collection('Comment')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final commentCount =
                snapshot.data!.docs.length;
            return Flexible(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          myFocusNode.requestFocus();
                        },
                        icon: const Icon(
                            FontAwesomeIcons.solidComment,
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
