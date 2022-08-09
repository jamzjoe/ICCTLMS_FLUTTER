import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/home_pages/class.dart';
import 'package:icct_lms/models/joined_model.dart';
import 'package:icct_lms/room_screens/room.dart';
import 'package:icct_lms/services/join.dart';

class StudentJoinedClassStream extends StatelessWidget {
  const StudentJoinedClassStream(
      {Key? key, required this.widget, required this.context})
      : super(key: key);
  final ClassScreen widget;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<JoinedModel>?>(
        stream: readJoinedClass(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData) {
            final classes = snapshot.data!;

            if (classes.isEmpty) {
              return const NoData(
                noDataText: 'No joined '
                    'streams yet'
                    '...',
              );
            }
            return ListView(
              children: classes.map(buildClassList).toList(),
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

  Stream<List<JoinedModel>> readJoinedClass() => FirebaseFirestore.instance
      .collection('Joined')
      .doc('Class')
      .collection(widget.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => JoinedModel.fromJson(doc.data()))
          .toList());

  Widget buildClassList(JoinedModel e) => Card(
        child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Room(
                        uid: widget.uid,
                        userName: widget.userName,
                        teacherUID: e.teacherUID,
                        teacher: e.teacher,
                        roomName: e.roomName,
                        roomType: e.roomType,
                        roomCode: e.roomCode,
                        userType: 'Student',
                      )));
            },
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue[900],
              child: Text(
                e.roomName.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
            title: Text(e.roomName),
            subtitle: Text('Teacher: ${e.teacher}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () {
                    final Joined join = Joined(uid: widget.uid);
                    join.deleteJoin(
                        e.roomType, e.roomCode, e.userID, e.teacherUID);
                  },
                  child: Text('Leave ${e.roomType}'),
                )
              ],
            )),
      );
}
