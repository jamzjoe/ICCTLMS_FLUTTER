import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/components/not_found.dart';
import 'package:icct_lms/home_pages/home.dart';
import 'package:icct_lms/home_pages/post_streams/tiles/post_tiles.dart';
import 'package:icct_lms/models/joined_model.dart';
import 'package:icct_lms/models/post_model.dart';

class JoinedStreams extends StatelessWidget {
  const JoinedStreams({Key? key, required this.widget, required this.context})
      : super(key: key);
  final HomeScreen widget;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<JoinedModel>>(
        stream: readJoinedClass(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final List<String> room = data.map((e) => e.roomCode).toList();
            if (data.isEmpty) {
              return const NoData(noDataText: 'No group post yet...');
            }

            return StreamBuilder<List<PostModel>>(
                stream: readPost(room),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final post = snapshot.data!;
                    if (post.isEmpty) {
                      return const NoData(
                          noDataText: 'No group post yet...'
                              '...');
                    }
                    return ListView(
                      children: post
                          .map((e) => createTiles(
                              e: e, context: context, widget: widget))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    return const NotFound(notFoundText: 'Something went wrong');
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                });
          } else if (snapshot.hasError) {
            return const NotFound(notFoundText: 'Something went wrong.');
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }

  Stream<List<JoinedModel>> readJoinedClass() {
    return FirebaseFirestore.instance
        .collection('Joined')
        .doc('Class')
        .collection(widget.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => JoinedModel.fromJson(e.data())).toList());
  }

  Stream<List<PostModel>> readPost(List<String> room) {
    return FirebaseFirestore.instance
        .collection('Post')
        .where('roomCode', whereIn: room)
        .orderBy('sortKey', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromJson(doc.data()))
            .toList());
  }
}
