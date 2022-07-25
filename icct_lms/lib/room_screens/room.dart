import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/room_screens/pages/folder.dart';
import 'package:icct_lms/room_screens/pages/member.dart';
import 'package:icct_lms/room_screens/pages/post.dart';
import 'package:lottie/lottie.dart';
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
    return StreamBuilder<DocumentSnapshot>(
        stream: readLinks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const NoData();
          }
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
                            final data = snapshot.data!;
                            try {
                              snapshot.data!['attendance'];
                            } catch (e) {
                              if (widget.userType == 'Teacher') {
                                buildDialog(
                                    widget.roomType,
                                    widget.roomName,
                                    widget.uid,
                                    widget.teacherUID,
                                    widget.teacher,
                                    "Attendance",
                                    widget.roomCode,
                                    attendanceController);
                              } else {
                                showError('Class');
                              }
                              return;
                            } finally {
                              if (widget.userType == 'Teacher') {
                                attendanceController.text = data['attendance'];
                                buildDialogForUpdates(
                                    widget.roomType,
                                    widget.roomName,
                                    widget.uid,
                                    widget.teacherUID,
                                    widget.teacher,
                                    "Attendance",
                                    widget.roomCode,
                                    attendanceController,
                                    data['attendance']);
                              }
                            }
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
                          onPressed: () async {
                            final data = snapshot.data!;
                            try {
                              snapshot.data!['virtual'];
                            } catch (e) {
                              if (widget.userType == 'Teacher') {
                                buildDialog(
                                    widget.roomType,
                                    widget.roomName,
                                    widget.uid,
                                    widget.teacherUID,
                                    widget.teacher,
                                    "Virtual",
                                    widget.roomCode,
                                    virtualController);
                              } else {
                                showError('Class');
                              }
                              return;
                            } finally {
                              if (widget.userType == 'Teacher') {
                                virtualController.text = data['virtual'];
                                buildDialogForUpdates(
                                    widget.roomType,
                                    widget.roomName,
                                    widget.uid,
                                    widget.teacherUID,
                                    widget.teacher,
                                    "Virtual",
                                    widget.roomCode,
                                    virtualController,
                                    data['virtual']);
                              }
                            }
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
                    roomCode: widget.roomCode,
                    roomName: widget.roomName,
                    teacherUID: widget.teacherUID,
                    teacher: widget.teacher,
                    userType: widget.roomType,
                    roomType: widget.roomType,
                    userName: widget.userName,
                  ),
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
        });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> readLinks() =>
      FirebaseFirestore.instance
          .collection('Rooms')
          .doc(widget.roomType)
          .collection(widget.teacherUID)
          .doc(widget.roomCode)
          .snapshots();

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
                      onPressed: () {
                        addOrUpdateLinks(
                            roomName,
                            roomCode,
                            teacher,
                            virtualController.text.trim(),
                            attendanceController.text.trim(),
                            roomType,
                            teacherUID);
                      },
                      child: const Text('Confirm')),
                ],
              ));

  Future openBrowserUrl(String url, bool inApp, String type) async {
    try {
      if (url.isEmpty || !Uri.parse(url).isAbsolute) {
        showError(type);
      }
      {
        await launch(url,
            forceWebView: inApp, forceSafariVC: true, enableJavaScript: true);
      }
    } catch (e) {
      return;
    }
  }

  Future showError(String type) => showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            content: Column(
              children: [
                Lottie.asset('assets/not.json', width: 150),
                Text('$type link not found or not a valid URL.')
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
                      placeholder: 'Paste $s link',
                      controller: controller,
                    ),
                  ],
                )),
                actions: [
                  TextButton(
                      onPressed: () {
                        addOrUpdateLinks(
                            roomName,
                            roomCode,
                            teacher,
                            virtualController.text.trim(),
                            attendanceController.text.trim(),
                            roomType,
                            teacherUID);
                      },
                      child: const Text('Update')),
                  TextButton(
                      onPressed: () {
                        openBrowserUrl(controller.text.trim(), false, s);
                      },
                      child: const Text('View')),
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
      attendanceController.text = '';
      virtualController.text = '';
    });
  }
}
