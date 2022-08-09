import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/comment_room/comment.dart';
import 'package:icct_lms/models/heart_model.dart';

class HeartStreams extends StatelessWidget {
  const HeartStreams({Key? key, required this.widget}) : super(key: key);
  final Comment widget;
  @override
  Widget build(BuildContext context) {
    return
      StreamBuilder<List<HeartModel>>(
          stream: FirebaseFirestore.instance
              .collection('Post')
              .doc(widget.e.postID)
              .collection('Heart')
              .snapshots()
              .map((event) => event.docs
              .map((e) => HeartModel.fromJson(e.data()))
              .toList()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              final heartCount = data.length;
              return Flexible(
                child: Row(
                  children: [
                    InkWell(
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      canRequestFocus: false,
                      onLongPress: () async {
                        await service.decrementHeart(
                            widget.e.postID, widget.userID);
                      },
                      child: StreamBuilder<
                          List<HeartModel>>(
                          stream: FirebaseFirestore.instance
                              .collection('Post')
                              .doc(widget.e.postID)
                              .collection('Heart')
                              .where('userID',
                              whereIn: [widget.userID])
                              .snapshots()
                              .map((event) => event.docs
                              .map((e) =>
                              HeartModel.fromJson(
                                  e.data()))
                              .toList()),
                          builder: (context, joe) {
                            if (joe.hasData) {
                              final data = joe.data!;

                              if (data.isEmpty) {
                                return IconButton(
                                  focusColor:
                                  Colors.transparent,
                                  splashColor:
                                  Colors.transparent,
                                  onPressed: () {
                                    service.incrementHeart(
                                        widget.e.postID,
                                        widget.username,
                                        widget.userID,
                                        widget.userType,
                                        'true');
                                  },
                                  icon: const Icon(
                                      FontAwesomeIcons
                                          .solidHeart,
                                      color: Colors.grey),
                                );
                              }
                              return IconButton(
                                focusColor:
                                Colors.transparent,
                                splashColor:
                                Colors.transparent,
                                onPressed: () {
                                  service.incrementHeart(
                                      widget.e.postID,
                                      widget.username,
                                      widget.userID,
                                      widget.userType,
                                      'true');
                                },
                                icon: const Icon(
                                    FontAwesomeIcons
                                        .solidHeart,
                                    color: Colors.red),
                              );
                            } else {
                              return IconButton(
                                focusColor:
                                Colors.transparent,
                                splashColor:
                                Colors.transparent,
                                onPressed: () {
                                  service.incrementHeart(
                                      widget.e.postID,
                                      widget.username,
                                      widget.userID,
                                      widget.userType,
                                      'true');
                                },
                                icon: const Icon(
                                    FontAwesomeIcons
                                        .solidHeart,
                                    color: Colors.grey),
                              );
                            }
                          }),
                    ),
                    Text(heartCount.toString())
                  ],
                ),
              );
            }
            return Flexible(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      service.incrementHeart(
                          widget.e.postID,
                          widget.username,
                          widget.userID,
                          widget.userType,
                          'true');
                    },
                    icon: const Icon(
                        FontAwesomeIcons.solidHeart),
                    color: Colors.grey,
                  ),
                  const Text('0')
                ],
              ),
            );
          });
  }
}
