import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/home_pages/class.dart';
import 'package:icct_lms/room_screens/room.dart';
import 'package:icct_lms/services/class_service.dart';
import 'package:icct_lms/services/post.dart';

import '../../models/class_model.dart';

class TeacherClassStream extends StatelessWidget {
  const TeacherClassStream(
      {Key? key, required this.widget, required this.context})
      : super(key: key);
  final ClassScreen widget;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Class>?>(
        stream: readClass(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData) {
            final classes = snapshot.data!;

            if (classes.isEmpty) {
              return const NoData(
                noDataText: 'No streams yet'
                    '...',
              );
            }
            return ListView(
              children: classes.map(buildUser).toList(),
            );
          } else {
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.blue[900],
              ),
            );
          }
        });
  }

  Widget buildUser(Class e) => Card(
        child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Room(
                        uid: widget.uid,
                        userName: widget.userName,
                        teacherUID: widget.uid,
                        teacher: e.teacher,
                        roomName: e.name,
                        roomType: 'Class',
                        roomCode: e.code,
                        userType: 'Teacher',
                      )));
            },
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue[900],
              child: Text(
                e.name.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
            title: Text(e.name),
            subtitle: Text('Teacher: ${e.teacher}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () async {
                    final ClassService service = ClassService();
                    final PostService post = PostService();
                    await service.deleteRoom("Class", widget.uid, e.code);
                    await post.deleteEachRoomPost(e.code);
                  },
                  child: const Text('Delete'),
                )
              ],
            )),
      );

  //streams
  Stream<List<Class>> readClass() => FirebaseFirestore.instance
      .collection('Rooms')
      .doc('Class')
      .collection(widget.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Class.fromJson(doc.data())).toList());
}
