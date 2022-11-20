import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/comment_room/comment.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/models/heart_model.dart';
import 'package:icct_lms/models/post_model.dart';
import 'package:icct_lms/quiz/create_quiz.dart';
import 'package:icct_lms/room_screens/pages/update_post.dart';
import 'package:icct_lms/room_screens/pages/write_post.dart';
import 'package:icct_lms/services/comment.dart';
import 'package:icct_lms/services/post.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Post extends StatefulWidget {
  const Post(
      {Key? key,
      required this.uid,
      required this.userType,
      required this.userName,
      required this.roomType,
      required this.roomCode,
      required this.teacher,
      required this.roomName,
      required this.teacherUID})
      : super(key: key);
  final String uid;
  final String userType;
  final String userName;
  final String roomType;
  final String roomCode;
  final String teacher;
  final String roomName;
  final String teacherUID;

  @override
  State<Post> createState() => _PostState();
}

final currentUserID = FirebaseAuth.instance.currentUser!.uid;
final CommentService service = CommentService();

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildTextField(widget),
          StreamBuilder<List<PostModel>>(
              stream: readPost(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  if (data.isEmpty) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          NoData(noDataText: 'No post yet...'),
                        ],
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      children: data.map(buildPostTiles).toList(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong...'),
                  );
                } else {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SpinKitFadingCircle(
                          color: Colors.blue,
                          size: 50,
                        )
                      ],
                    ),
                  );
                }
              })
        ],
      ),
      floatingActionButton: Visibility(
        visible: widget.userType == 'Teacher',
        child: SpeedDial(
          onPress: () {
            showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                enableDrag: true,
                context: context,
                builder: (context) => ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: Container(
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                const Text('Create',
                                    style: TextStyle(fontSize: 20)),
                                ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      createPost(context);
                                    },
                                    leading: const Icon(Icons.create),
                                    title: const Text('Post')),
                                ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      createQuiz();
                                    },
                                    leading: const Icon(Icons.quiz),
                                    title: const Text('Quiz')),
                              ],
                            )),
                      ),
                    ));
          },
          overlayColor: Colors.black54,
          backgroundColor: Colors.blue[900],
          spaceBetweenChildren: 10,
          animatedIcon: AnimatedIcons.add_event,
        ),
      ),
    );
  }

  Stream<List<PostModel>> readPost() => FirebaseFirestore.instance
      .collection('Post')
      .where('roomCode', isEqualTo: widget.roomCode)
      .orderBy('sortKey', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList());

  // Stream<List<PostModel>> readPost() => FirebaseFirestore.instance
  //     .collection('Rooms')
  //     .doc(widget.roomType)
  //     .collection(widget.teacherUID)
  //     .doc(widget.roomCode)
  //     .collection('Post')
  //     .orderBy('sortKey', descending: true)
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList());

  Widget buildTextField(Post widget) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () {
            createPost(context);
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: widget.userType == 'Teacher'
                    ? Colors.blue[900]
                    : Colors.redAccent,
                child: Text(
                  widget.userName.substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  height: 50,
                  width: 300,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  child: const Text(
                    "What's on your mind ?",
                    style: TextStyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildPostTiles(PostModel e) => Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: e.userType == 'Teacher'
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.postName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  e.userType,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              '${e.date}, ${e.hour} ',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 12),
                            ),
                          ],
                        ),
                        PopupMenuButton(
                          icon: const Icon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 15,
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                onTap: () async {
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  if (!mounted) {
                                    return;
                                  }
                                  if (e.userID != widget.uid) {
                                    showError("You can't edit someone's post.");
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => UpdatePost(
                                                uid: e.userID,
                                                sortKey: e.sortKey,
                                                date: e.date,
                                                postID: e.postID,
                                                message: e.message,
                                                userType: widget.userType,
                                                userName: e.postName,
                                                roomType: widget.roomType,
                                                roomCode: widget.roomCode,
                                                roomName: widget.roomName,
                                                teacherUID:
                                                    widget.teacherUID)));
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.edit,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Edit post',
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ],
                                )),
                            PopupMenuItem(
                                onTap: () async {
                                  final PostService post = PostService();
                                  if (widget.uid != e.userID) {
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    showError(
                                        "You can't delete someone's post.");
                                  } else {
                                    await post.deletePublicPost(e.postID);
                                    // await post.deletePost(
                                    //     widget.roomType,
                                    //     widget.teacherUID,
                                    //     widget.roomCode,
                                    //     e.message,
                                    //     e.postName,
                                    //     e.userID,
                                    //     e.postID);
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.deleteLeft,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Delete post',
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ],
                                )),
                            PopupMenuItem(
                                onTap: () async {
                                  final PostService post = PostService();
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.thumbtack,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Make pin',
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SelectableLinkify(
                          options: const LinkifyOptions(humanize: true),
                          onOpen: (link) async {
                            launch(link.url);
                          },
                          text: e.message,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                          linkStyle: const TextStyle(color: Colors.blue),
                        ),
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

  Future showError(String errorMessage) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/error.json', width: 150),
                Text(errorMessage)
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay'))
            ],
          ));

  Future share(String message, String name) async {
    await Share.share('Post from $name \n $message');
  }

  Future createPost(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WritePost(
                  uid: widget.uid,
                  userType: widget.userType,
                  roomType: widget.roomType,
                  userName: widget.userName,
                  roomCode: widget.roomCode,
                  roomName: widget.roomName,
                  teacherUID: widget.teacherUID,
                )));
  }

  void createQuiz() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateQuiz(
                  roomID: widget.roomCode,
                  professor: widget.teacher,
                )));
  }
}
