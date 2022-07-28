import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icct_lms/services/class_service.dart';

class RoomSettings extends StatefulWidget {
  const RoomSettings(
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
  State<RoomSettings> createState() => _RoomSettingsState();
}

final String currentUser = FirebaseAuth.instance.currentUser!.uid;
final ClassService service = ClassService();

class _RoomSettingsState extends State<RoomSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: readSettings(),
          builder: (context, snapshot) {

             if(snapshot.connectionState == ConnectionState.waiting ||
                 snapshot.hasError){
              return Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue[900],
                ),
              );
            }else{
                // ignore: control_flow_in_finally
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Visibility(
                              visible: widget.userType == 'Teacher',
                              child: buildSettingsTile(
                                  'Allow student to post',
                                  snapshot.data!['restriction'] == 'false'
                                      ? true
                                      : false),
                            ),
                            buildCopy(widget.roomCode, 'Copy room code', 'Roo'
                                'm Code'),
                            buildCopy(widget.teacherUID, 'Copy teacher UID',
                                "Teacher UID")
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }


          }),
    );
  }

  Widget buildSettingsTile(String title, bool isOn) => Card(
        child: ListTile(
          title: Text(title),
          trailing: Switch.adaptive(
              value: isOn,
              onChanged: (value) {
                print(widget.uid);
                service.switchRestriction(widget.roomType, currentUser,
                    widget.roomCode, isOn.toString());
              }),
        ),
      );

  Stream<DocumentSnapshot<Map<String, dynamic>>> readSettings() =>
      FirebaseFirestore.instance
          .collection('Rooms')
          .doc(widget.roomType)
          .collection(widget.teacherUID)
          .doc(widget.roomCode)
          .snapshots();

  Widget buildCopy(String copy, String title, String subtitle) => Card(
    child: ListTile(
      subtitle: Text(copy),
      title: Text(title),
      trailing: IconButton(
          onPressed: () async {
            await FlutterClipboard.copy(copy);
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You copied ID:$copy'),
                duration: const Duration(milliseconds: 1000),
              ),
            );
          },
          icon: const Icon(
            Icons.copy_outlined,
            size: 20,
            color: Colors.black54,
          ))
    ),
  );
}
