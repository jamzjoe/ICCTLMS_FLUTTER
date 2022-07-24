import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/room_screens/pages/folder.dart';
import 'package:icct_lms/room_screens/pages/member.dart';
import 'package:icct_lms/room_screens/pages/post.dart';

class Room extends StatefulWidget {
  const Room(
      {Key? key,
      required this.uid,
      required this.teacherUID,
      required this.teacher,
      required this.roomName,
      required this.roomType,
      required this.roomCode})
      : super(key: key);
  final String uid;
  final String teacherUID;
  final String teacher;
  final String roomName;
  final String roomType;
  final String roomCode;
  @override
  State<Room> createState() => _RoomState();
}

final attendanceController = TextEditingController();
final virtualController = TextEditingController();

class _RoomState extends State<Room> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          elevation: 2,
          backgroundColor: Colors.blue[900],
          title: Text(
            '${widget.roomName} - ${widget.roomType}',
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                    onPressed: () {
                      buildDialog(
                          widget.roomType,
                          widget.roomName,
                          widget.uid,
                          widget.teacherUID,
                          widget.teacher,
                          "Attendance",
                          widget.roomCode,
                          attendanceController);
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ));
              },
            ),
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                    onPressed: () {
                      buildDialog(
                          widget.roomType,
                          widget.roomName,
                          widget.uid,
                          widget.teacherUID,
                          widget.teacher,
                          'Virtual',
                          widget.roomCode,
                          virtualController);
                    },
                    icon: const Icon(
                      Icons.video_camera_back,
                      color: Colors.white,
                    ));
              },
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue[900],
            indicatorWeight: 2,
            tabs: const [
              Tab(
                text: 'Timeline',
                icon: Icon(Icons.post_add),
              ),
              Tab(
                text: 'Sources',
                icon: Icon(Icons.folder),
              ),
              Tab(
                text: 'Members',
                icon: Icon(Icons.group),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Post(
                uid: widget.uid,
                userType: widget.roomType,
                userName: widget.teacher,
                roomType: widget.roomType),
            Folder(
                uid: widget.uid,
                userType: widget.roomType,
                userName: widget.teacher,
                roomType: widget.roomType),
            Member(
                uid: widget.uid,
                userType: widget.roomType,
                userName: widget.teacher,
                roomType: widget.roomType),
          ],
        ),
      ),
    );
  }

  Future buildDialog(
    String roomType,
    String roomName,
    String uid,
    String teacherUID,
    String teacher,
    String buttonType,
    String roomCode,
    TextEditingController controller,
  ) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Add/Update'),
                content: Form(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                          hintText: 'Input $buttonType link',
                          label: Text('$buttonType Link')),
                    )
                  ],
                )),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () async {
                        final CollectionReference addLinks =
                            FirebaseFirestore.instance.collection("Rooms");

                        await addLinks
                            .doc(roomType)
                            .collection(teacherUID)
                            .doc(roomCode)
                            .set({
                          'code': roomCode,
                          'name': roomName,
                          'teacher': teacher,
                          'virtual': virtualController.text.trim(),
                          'attendance': attendanceController.text.trim(),
                        }).whenComplete(() {
                          Navigator.pop(context);
                          controller.text = '';
                        });
                      },
                      child: const Text('Confirm')),
                ],
              ));
}
