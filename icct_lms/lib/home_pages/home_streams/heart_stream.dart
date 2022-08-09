import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/home_pages/home.dart';
import 'package:icct_lms/models/heart_model.dart';
import 'package:icct_lms/models/post_model.dart';

class HomeHeartStreams extends StatelessWidget {
  const HomeHeartStreams({Key? key, required this.widget, required this.e})
      : super(key: key);
  final HomeScreen widget;
  final PostModel e;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<HeartModel>>(
        stream: FirebaseFirestore.instance
            .collection('Post')
            .doc(e.postID)
            .collection('Heart')
            .snapshots()
            .map((event) =>
                event.docs.map((e) => HeartModel.fromJson(e.data())).toList()),
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
                      await service.decrementHeart(e.postID, widget.uid);
                    },
                    child: StreamBuilder<List<HeartModel>>(
                        stream: FirebaseFirestore.instance
                            .collection('Post')
                            .doc(e.postID)
                            .collection('Heart')
                            .where('userID', whereIn: [widget.uid])
                            .snapshots()
                            .map((event) => event.docs
                                .map((e) => HeartModel.fromJson(e.data()))
                                .toList()),
                        builder: (context, joe) {
                          if (joe.hasData) {
                            final data = joe.data!;

                            if (data.isEmpty) {
                              return IconButton(
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  service.incrementHeart(
                                      e.postID,
                                      widget.userName,
                                      widget.uid,
                                      widget.userType,
                                      'true');
                                },
                                icon: const Icon(FontAwesomeIcons.solidHeart,
                                    color: Colors.grey),
                              );
                            }
                            return IconButton(
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                service.incrementHeart(
                                    e.postID,
                                    widget.userName,
                                    widget.uid,
                                    widget.userType,
                                    'true');
                              },
                              icon: const Icon(FontAwesomeIcons.solidHeart,
                                  color: Colors.red),
                            );
                          } else {
                            return IconButton(
                              focusColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                service.incrementHeart(
                                    e.postID,
                                    widget.userName,
                                    widget.uid,
                                    widget.userType,
                                    'true');
                              },
                              icon: const Icon(FontAwesomeIcons.solidHeart,
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
                    service.incrementHeart(e.postID, widget.userName,
                        widget.uid, widget.userType, 'true');
                  },
                  icon: const Icon(FontAwesomeIcons.solidHeart),
                  color: Colors.grey,
                ),
                const Text('0')
              ],
            ),
          );
        });
  }
}
