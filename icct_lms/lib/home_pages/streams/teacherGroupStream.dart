import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/home_pages/class.dart';
import 'package:icct_lms/models/group_model.dart';
import 'package:icct_lms/room_screens/room.dart';
import 'package:icct_lms/services/class_service.dart';
import 'package:icct_lms/services/post.dart';

class TeacherGroupStream extends StatelessWidget {
  const TeacherGroupStream(
      {Key? key, required this.widget, required this.context})
      : super(key: key);
  final ClassScreen widget;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Group>?>(
        stream: readGroup(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData) {
            final group = snapshot.data!;

            if (group.isEmpty) {
              return const NoData(
                noDataText: 'No group yet'
                    '...',
              );
            }
            return ListView(
              children: group.map(buildGroup).toList(),
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

  Stream<List<Group>> readGroup() => FirebaseFirestore.instance
      .collection('Rooms')
      .doc('Group')
      .collection(widget.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());

  Widget buildGroup(Group e) => Card(
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Room(
                      uid: widget.uid,
                      teacherUID: widget.uid,
                      userName: widget.userName,
                      teacher: e.teacher,
                      roomCode: e.code,
                      roomName: e.name,
                      roomType: 'Group',
                      userType: 'Teacher',
                    )));
          },
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.redAccent,
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
                  await service.deleteRoom("Group", widget.uid, e.code);
                  await post.deleteEachRoomPost(e.code);
                },
                child: const Text('Delete'),
              )
            ],
          ),
        ),
      );
}
