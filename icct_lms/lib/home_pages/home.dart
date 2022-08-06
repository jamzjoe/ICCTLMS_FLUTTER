import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/comment_room/comment.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/components/not_found.dart';
import 'package:icct_lms/models/class_model.dart';
import 'package:icct_lms/models/group_model.dart';
import 'package:icct_lms/models/heart_model.dart';
import 'package:icct_lms/models/joined_model.dart';
import 'package:icct_lms/models/post_model.dart';
import 'package:icct_lms/services/comment.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {Key? key,
      required this.uid,
      required this.userType,
      required this.userName,
      required this.userEmail,
      required this.userCampus})
      : super(key: key);
  final String uid;
  final String userType;
  final String userName;
  final String userEmail;
  final String userCampus;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final CommentService service = CommentService();

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(seconds: 1),
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 0,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blue[900],
            indicatorWeight: 2,
            tabs: const [
              Tab(
                text: 'Class Posts',
              ),
              Tab(
                text: 'Group Posts',
              ),
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          overlayColor: Colors.black54,
          backgroundColor: Colors.blue[900],
          spaceBetweenChildren: 10,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                child: const Icon(CupertinoIcons.create),
                label: 'Post',
                labelBackgroundColor: Colors.yellow,
                backgroundColor: Colors.yellow),
            SpeedDialChild(
                child: const Icon(CupertinoIcons.chat_bubble),
                label: 'Message',
                labelBackgroundColor: Colors.yellow,
                backgroundColor: Colors.yellow)
          ],
        ),
        body: TabBarView(children: [
          widget.userType == "Student"
              ? StreamBuilder<List<JoinedModel>>(
                  stream: readJoinedClass(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final List<String> room =
                          data.map((e) => e.roomCode).toList();
                      if (data.isEmpty) {
                        return const NoData(noDataText: 'No class post yet');
                      }

                      return StreamBuilder<List<PostModel>>(
                          stream: readPost(room),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final post = snapshot.data!;
                              if (post.isEmpty) {
                                return const NoData(
                                    noDataText: 'No class post yet'
                                        '...');
                              }
                              return ListView(
                                children: post.map(createTiles).toList(),
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
                    } else if (snapshot.hasError) {
                      return const NotFound(
                          notFoundText: 'Something went wrong.');
                    } else {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  })
              : StreamBuilder<List<Class>>(
                  stream: readClassForTeacher(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final List<String> room =
                          data.map((e) => e.code).toList();
                      if (data.isEmpty) {
                        return const NoData(noDataText: 'No class post yet');
                      }

                      return StreamBuilder<List<PostModel>>(
                          stream: readPost(room),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final post = snapshot.data!;
                              if (post.isEmpty) {
                                return const NoData(
                                    noDataText: 'No class post yet'
                                        '...');
                              }
                              return ListView(
                                children: post.map(createTiles).toList(),
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
                    } else if (snapshot.hasError) {
                      return const NotFound(
                          notFoundText: 'Something went wrong.');
                    } else {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  }),
          widget.userType == "Student"
              ? StreamBuilder<List<JoinedModel>>(
                  stream: readJoinedGroup(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final List<String> room =
                          data.map((e) => e.roomCode).toList();
                      if (data.isEmpty) {
                        return const NoData(noDataText: 'No group post yet');
                      }

                      return StreamBuilder<List<PostModel>>(
                          stream: readPost(room),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final post = snapshot.data!;
                              if (post.isEmpty) {
                                return const NoData(
                                    noDataText: 'No group post yet'
                                        '...');
                              }
                              return ListView(
                                children: post.map(createTiles).toList(),
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
                    } else if (snapshot.hasError) {
                      return const NotFound(
                          notFoundText: 'Something went wrong.');
                    } else {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  })
              : StreamBuilder<List<Group>>(
                  stream: readGroupForTeacher(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final List<String> room =
                          data.map((e) => e.code).toList();
                      if (data.isEmpty) {
                        return const NoData(noDataText: 'No group post yet');
                      }

                      return StreamBuilder<List<PostModel>>(
                          stream: readPost(room),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final post = snapshot.data!;
                              if (post.isEmpty) {
                                return const NoData(
                                    noDataText: 'No group post yet'
                                        '...');
                              }
                              return ListView(
                                children: post.map(createTiles).toList(),
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
                    } else if (snapshot.hasError) {
                      return const NotFound(
                          notFoundText: 'Something went wrong.');
                    } else {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  }),
        ]),
      ),
    );
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

  Stream<List<JoinedModel>> readJoinedGroup() {
    return FirebaseFirestore.instance
        .collection('Joined')
        .doc('Group')
        .collection(widget.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => JoinedModel.fromJson(e.data())).toList());
  }

  Stream<List<Class>> readClassForTeacher() {
    return FirebaseFirestore.instance
        .collection('Rooms')
        .doc('Class')
        .collection(widget.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Class.fromJson(e.data())).toList());
  }

  Stream<List<Group>> readGroupForTeacher() {
    return FirebaseFirestore.instance
        .collection('Rooms')
        .doc('Group')
        .collection(widget.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Group.fromJson(e.data())).toList());
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

  Widget createTiles(PostModel e) => InkWell(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Comment(
                      e: e,
                      username: widget.userName,
                      userType: widget.userType,
                      userID: widget.uid)));
        },
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: e.userType == "Teacher"
                      ? Colors.blue[900]
                      : Colors.redAccent,
                  child: Center(
                    child: Text(
                      e.postName.substring(0, 2).toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                          TextSpan(text: e.postName),
                          const TextSpan(
                              text: ' posted from ',
                              style: TextStyle(fontWeight: FontWeight.w300)),
                          TextSpan(
                              text: e.roomName,
                              recognizer: TapGestureRecognizer()..onTap = () {})
                        ])),
                    Text(
                      e.userType,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 12),
                    ),
                    Text(
                      '${e.date} ${e.hour}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 12),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(15),
                  child: Column(
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StreamBuilder<List<HeartModel>>(
                        stream: FirebaseFirestore.instance
                            .collection('Post')
                            .doc(e.postID)
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
                                          e.postID, widget.uid);
                                    },
                                    child: StreamBuilder<List<HeartModel>>(
                                        stream: FirebaseFirestore.instance
                                            .collection('Post')
                                            .doc(e.postID)
                                            .collection('Heart')
                                            .where('userID',
                                                whereIn: [widget.uid])
                                            .snapshots()
                                            .map((event) => event.docs
                                                .map((e) => HeartModel.fromJson(
                                                    e.data()))
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
                                                icon: const Icon(
                                                    FontAwesomeIcons.solidHeart,
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
                                              icon: const Icon(
                                                  FontAwesomeIcons.solidHeart,
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
                                              icon: const Icon(
                                                  FontAwesomeIcons.solidHeart,
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
                                        e.postID,
                                        widget.userName,
                                        widget.uid,
                                        widget.userType,
                                        'true');
                                  },
                                  icon: const Icon(FontAwesomeIcons.solidHeart),
                                  color: Colors.grey,
                                ),
                                const Text('0')
                              ],
                            ),
                          );
                        }),
                    StreamBuilder<QuerySnapshot>(
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
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Comment(
                                                  e: e,
                                                  username: widget.userName,
                                                  userID: widget.uid,
                                                  userType: widget.userType)));
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
                        }),
                    Flexible(
                      child: IconButton(
                        onPressed: () {
                          share(e.message, e.postName);
                        },
                        icon: const Icon(FontAwesomeIcons.shareNodes),
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Future share(String message, String name) async {
    await Share.share('Post from $name \n $message');
  }
}
