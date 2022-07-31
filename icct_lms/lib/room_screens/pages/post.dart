import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/components/loading.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/models/post_model.dart';
import 'package:icct_lms/room_screens/pages/update_post.dart';
import 'package:icct_lms/room_screens/pages/write_post.dart';
import 'package:icct_lms/services/post.dart';
import 'package:lottie/lottie.dart';
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

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          buildTextField(widget),
          SingleChildScrollView(child: buildPost())
        ],
      ),
    );
  }

  Stream<List<PostModel>> readPost() => FirebaseFirestore.instance
      .collection('Rooms')
      .doc(widget.roomType)
      .collection(widget.teacherUID)
      .doc(widget.roomCode)
      .collection('Post')
      .orderBy('sortKey', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => PostModel.fromJson(doc.data())).toList());

  Widget buildTextField(Post widget) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () {
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

  Widget buildPost() => StreamBuilder<List<PostModel>?>(
      stream: readPost(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.hasData) {
          final classes = snapshot.data!;

          if (classes.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                IntrinsicHeight(child: Center(child: NoData())),
              ],
            );
          }
          return Column(
            children: classes.map(buildPostTiles).toList(),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:const [
              SpinKitFadingCircle(
                color: Colors.blue,
              )
            ],
          );
        }
      });

  Widget buildPostTiles(PostModel e) => Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  e.userType == 'Teacher' ? Colors.blue[900] : Colors.redAccent,
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
                        Text(
                          '${e.postName} - ${e.userType}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          e.date,
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
                              await Future.delayed(const Duration(seconds: 1));
                              if (!mounted) {
                                return;
                              }
                              if (e.userID != widget.uid) {
                                showError("You can't edit someone's post.");
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
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
                                        teacherUID: widget.teacherUID)));
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
                              print(e.userID);
                              if (widget.uid != e.userID) {
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                showError("You can't delete someone's post.");
                              } else {
                                await post.deletePost(
                                    widget.roomType,
                                    widget.teacherUID,
                                    widget.roomCode,
                                    e.message,
                                    e.postName,
                                    e.userID,
                                    e.postID);
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableLinkify(
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
                )
              ],
            ),
            isThreeLine: true,
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
}
