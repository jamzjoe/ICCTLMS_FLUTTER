import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:icct_lms/comment_room/comment.dart';
import 'package:icct_lms/components/not_found.dart';
import 'package:icct_lms/models/comment_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

class CommentStream extends StatelessWidget {
  const CommentStream({Key? key, required this.widget}) : super(key: key);
  final Comment widget;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentModel>>(
        stream: readComments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return const Text('No comment yet...');
            }
            return ScrollablePositionedList.builder(
              shrinkWrap: true,
              itemScrollController: itemController,
              itemBuilder: (BuildContext context, int index) {
                return data.map(createCommentTiles).toList()[index];
              },
              itemCount: data.length,
            );
          } else if (snapshot.hasError) {
            return const NotFound(
                notFoundText: 'Something went wrong');
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }


  Stream<List<CommentModel>> readComments() => FirebaseFirestore.instance
      .collection('Post')
      .doc(widget.e.postID)
      .collection('Comment')
      .orderBy('sortKey', descending: false)
      .snapshots()
      .map((event) =>
      event.docs.map((e) => CommentModel.fromJson(e.data())).toList());

  Widget createCommentTiles(CommentModel e) => Column(
    children: [
      ListTile(
        leading: CircleAvatar(
          child: Center(
            child: Text(e.name.substring(0, 2).toUpperCase()),
          ),
        ),
        title: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.name),
                Text(
                  e.userType,
                  style: const TextStyle(
                      fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableLinkify(
                      options: const LinkifyOptions(humanize: true),
                      text: e.message,
                      onOpen: (link) async {
                        launch(link.url);
                      },
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                      linkStyle: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}


