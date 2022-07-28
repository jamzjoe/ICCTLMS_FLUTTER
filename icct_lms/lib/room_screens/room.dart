import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/room_screens/pages/folder.dart';
import 'package:icct_lms/room_screens/pages/member.dart';
import 'package:icct_lms/room_screens/pages/post.dart';
import 'package:icct_lms/room_screens/pages/room_settings.dart';
import 'package:icct_lms/services/class_service.dart';
import 'package:lottie/lottie.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class Room extends StatefulWidget {
  const Room(
      {Key? key,
      required this.uid,
      required this.teacherUID,
      required this.teacher,
      required this.roomName,
      required this.roomType,
      required this.roomCode,
      required this.userType,
      required this.userName})
      : super(key: key);
  final String uid;
  final String teacherUID;
  final String teacher;
  final String roomName;
  final String userType;
  final String roomType;
  final String roomCode;
  final String userName;
  @override
  State<Room> createState() => _RoomState();
}

final attendanceController = TextEditingController();
final virtualController = TextEditingController();
bool isError = false;
final CollectionReference addLinks =
    FirebaseFirestore.instance.collection("Rooms");

class _RoomState extends State<Room> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.teacherUID);
    return StreamBuilder<DocumentSnapshot>(
        stream: readLinks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const NoData();
          }

          return DefaultTabController(
            length: 4,
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
                          onPressed: () async {
                            final data = snapshot.data!;

                            final attendance = data['attendance'] ?? "Empty "
                                "attendance";
                            attendanceController.text = attendance;
                            await buildDialogForUpdates(
                                widget.roomType,
                                widget.roomName,
                                currentUserID,
                                currentUserID,
                                widget.teacher,
                                "Attendance",
                                widget.roomCode,
                                attendanceController,
                                attendance);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.calendarCheck,
                            size: 20,
                            color: Colors.white,
                          ));
                    },
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                          onPressed: () async {
                            final data = snapshot.data!;
                            final virtual = data['virtual'] ?? "Empty "
                                "virtual meeting link";
                            virtualController.text = virtual;


                             await buildDialogForUpdates(
                                  widget.roomType,
                                  widget.roomName,
                                  currentUserID,
                                  currentUserID,
                                  widget.teacher,
                                  "Virtual Meeting",
                                  widget.roomCode,
                                  virtualController,
                                  virtual);

                          },
                          icon: const Icon(
                            FontAwesomeIcons.video,
                            size: 18,
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
                    Tab(
                      text: "Settings",
                      icon: Icon(Icons.settings),
                    )
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Post(
                    uid: widget.uid,
                    roomCode: widget.roomCode,
                    roomName: widget.roomName,
                    teacherUID: widget.teacherUID,
                    teacher: widget.teacher,
                    userType: widget.userType,
                    roomType: widget.roomType,
                    userName: widget.userName,
                  ),
                  Folder(
                      uid: widget.uid,
                      userType: widget.userType,
                      userName: widget.teacher,
                      roomType: widget.roomType),
                  Member(
                      uid: widget.uid,
                      userType: widget.userType,
                      userName: widget.teacher,
                      roomType: widget.roomType),
                  widget.userType == "Teacher"
                      ? RoomSettings(
                          uid: widget.uid,
                          roomCode: widget.roomCode,
                          roomName: widget.roomName,
                          teacherUID: widget.teacherUID,
                          teacher: widget.teacher,
                          userType: widget.userType,
                          roomType: widget.roomType,
                          userName: widget.userName,
                        )
                      : const Center(
                          child: Text('Only the teacher can see this page'
                              '.'),
                        )
                ],
              ),
            ),
          );
        });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> readLinks() =>
      FirebaseFirestore.instance
          .collection('Rooms')
          .doc(widget.roomType)
          .collection(widget.teacherUID)
          .doc(widget.roomCode)
          .snapshots();

  Future openBrowserUrl(String url, bool inApp, String type) async {
    if (isURL(url) && url.contains('https://')) {
      launch(url,
          forceWebView: inApp, forceSafariVC: true, enableJavaScript: true);
    } else if (url.isEmpty) {
      showError(type);
    } else {
      showError(type);
    }
  }

  Future showError(String type) => showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            content: Column(
              children: [
                Lottie.asset('assets/not.json', width: 150),
                Text('$type link not found, not a valid URL or not contains '
                    'https://.')
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

  Future buildDialogForUpdates(
          String roomType,
          String roomName,
          String uid,
          String teacherUID,
          String teacher,
          String s,
          String roomCode,
          TextEditingController controller,
          data) =>
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text('$s Link'),
                content: Form(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoTextField(
                      readOnly: widget.userType == 'Student',
                      placeholder: '$s link address.',
                      controller: controller,
                    ),
                  ],
                )),
                actions: [
                  Visibility(
                    visible: widget.userType == 'Teacher',
                    child: TextButton(
                        onPressed: () async {
                         final ClassService service = ClassService();
                         Navigator.pop(context);
                         await service.updateLinks(roomType, widget.teacherUID,
                             roomCode,
                             virtualController.text.trim(), attendanceController
                                 .text
                                 .trim());

                        },
                        child: controller.text.isEmpty
                            ? const Text('Add Link')
                            : const Text('Update Link')),
                  ),
                  Visibility(
                    visible: controller.text.isNotEmpty,
                    child: TextButton(
                        onPressed: () {
                          openBrowserUrl(data, false, s);
                        },
                        child: const Text('View Link')),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                ],
              ));

  Future addOrUpdateLinks(
      String roomName,
      String roomCode,
      String teacher,
      String virtual,
      String attendance,
      String roomType,
      String teacherUID) async {
    await addLinks.doc(roomType).collection(teacherUID).doc(roomCode).set({
      'code': roomCode,
      'name': roomName,
      'teacher': teacher,
      'virtual': virtual,
      'attendance': attendance,
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }
}
