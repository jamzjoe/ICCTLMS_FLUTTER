import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/models/post_model.dart';
import 'package:icct_lms/room_screens/pages/write_post.dart';

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
                          roomType: widget.userType,
                          userName: widget.userName,
                          roomCode: widget.roomCode,
                          roomName: widget.roomName,
                          teacherUID: widget.teacherUID,
                        )));
          },
          child: Row(
            children: [
              CircleAvatar(
                child: Text(widget.userName.substring(0, 2).toUpperCase()),
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
            return const NoData();
          }
          return Column(
            children: classes.map(buildPostTiles).toList(),
          );
        } else {
          return Center(
            child: SpinKitFadingCircle(
              color: Colors.blue[900],
            ),
          );
        }
      });

  Widget buildPostTiles(PostModel e) => Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[900],
              child: Center(
                child: Text(e.postName.substring(0, 2).toUpperCase()),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.postName),
                Text(
                  e.date,
                  style: const TextStyle(
                      fontWeight: FontWeight.w300, fontSize: 12),
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(e.message),
              ],
            ),
            trailing: const Icon(FontAwesomeIcons.ellipsis),
            isThreeLine: true,
          ),
        ),
      );
}
