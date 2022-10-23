import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/components/not_found.dart';
import 'package:icct_lms/home_pages/home.dart';
import 'package:icct_lms/home_pages/post_streams/tiles/post_tiles.dart';
import 'package:icct_lms/models/class_model.dart';
import 'package:icct_lms/models/post_model.dart';

class PostStreams extends StatefulWidget {
  const PostStreams({Key? key, required this.widget}) : super(key: key);
  final HomeScreen widget;

  @override
  State<PostStreams> createState() => _PostStreamsState();
}

List<PostModel> searchQuery = [];
final _searchController = TextEditingController();

class _PostStreamsState extends State<PostStreams> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Class>>(
        stream: readClassForTeacher(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final List<String> room = data.map((e) => e.code).toList();
            if (data.isEmpty) {
              return const NoData(noDataText: 'No class post yet...');
            }

            return StreamBuilder<List<PostModel>>(
                stream: readPost(room),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final post = snapshot.data!;
                    if (post.isEmpty) {
                      return const NoData(
                          noDataText: 'No streams post yet'
                              '...');
                    }
                    return ListView(
                      children: [
                        ...post
                            .map((e) => createTiles(
                                e: e, context: context, widget: widget.widget))
                            .toList()
                      ],
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

  Stream<List<Class>> readClassForTeacher() {
    return FirebaseFirestore.instance
        .collection('Rooms')
        .doc('Class')
        .collection(widget.widget.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Class.fromJson(e.data())).toList());
  }

  void searchPost(String query, List<PostModel> data) {
    final suggestions = data.where(((value) {
      final name = value.message.toLowerCase();
      final input = query.toLowerCase();

      return name.contains(input);
    })).toList();
    if (query.isEmpty) {
      setState(() {
        searchQuery = data;
      });
    } else {
      setState(() {
        searchQuery = suggestions;
      });
    }
  }
}

Stream<List<PostModel>> readPost(List<String> room) {
  return FirebaseFirestore.instance
      .collection('Post')
      .where('roomCode', whereIn: room)
      .orderBy('sortKey', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList());
}
