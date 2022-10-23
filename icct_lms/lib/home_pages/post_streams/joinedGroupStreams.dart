import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/components/not_found.dart';
import 'package:icct_lms/home_pages/home.dart';
import 'package:icct_lms/home_pages/post_streams/tiles/post_tiles.dart';
import 'package:icct_lms/models/joined_model.dart';
import 'package:icct_lms/models/post_model.dart';

class JoinedGroupStreams extends StatefulWidget {
  const JoinedGroupStreams(
      {Key? key, required this.widget, required this.context})
      : super(key: key);
  final HomeScreen widget;
  final BuildContext context;

  @override
  State<JoinedGroupStreams> createState() => _JoinedGroupStreamsState();
}

List<PostModel> searchQuery = [];
final _searchController = TextEditingController();

class _JoinedGroupStreamsState extends State<JoinedGroupStreams> {
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
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            onChanged: (value) {
                              searchPost(value, post);
                            },
                            controller: _searchController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search post',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.blue))),
                          ),
                        ),
                        ...searchQuery.isEmpty
                            ? post
                                .map((e) => createTiles(
                                    e: e,
                                    context: context,
                                    widget: widget.widget))
                                .toList()
                            : searchQuery
                                .map((e) => createTiles(
                                    e: e,
                                    context: context,
                                    widget: widget.widget))
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

  Stream<List<JoinedModel>> readJoinedClass() {
    return FirebaseFirestore.instance
        .collection('Joined')
        .doc('Group')
        .collection(widget.widget.uid)
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