import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:icct_lms/components/copy.dart';
import 'package:icct_lms/components/loading.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/home_pages/qr_scanner.dart';
import 'package:icct_lms/home_pages/streams/studentJoinedClassStream.dart';
import 'package:icct_lms/home_pages/streams/studentJoinedGroupStream.dart';
import 'package:icct_lms/home_pages/streams/teacherClassStream.dart';
import 'package:icct_lms/home_pages/streams/teacherGroupStream.dart';
import 'package:icct_lms/models/class_model.dart';
import 'package:icct_lms/models/group_model.dart';
import 'package:icct_lms/services/class_service.dart';
import 'package:icct_lms/services/post.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen(
      {Key? key,
      required this.uid,
      required this.userType,
      required this.userName,
      required this.userEmail,
      required this.userCampus})
      : super(key: key);
  final String uid;
  final String userType;
  final String userName;
  final String userEmail;
  final String userCampus;
  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

var initialClassCode = 'C${const Uuid().v1().substring(0, 8)}';
var initialGroupCode = 'G${const Uuid().v1().substring(0, 8)}';
final classCodeController = TextEditingController(text: initialClassCode);
final groupCodeController = TextEditingController(text: initialGroupCode);
final classNameController = TextEditingController();
final groupNameController = TextEditingController();
final joinGroupCodeController = TextEditingController();
final teacherGroupUIDController = TextEditingController();
final joinClassCodeController = TextEditingController();
final teacherClassUIDController = TextEditingController();
final CollectionReference joinReference =
    FirebaseFirestore.instance.collection('Joined');
final CollectionReference roomReference =
    FirebaseFirestore.instance.collection('Rooms');
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey<FormState> _qrKey = GlobalKey<FormState>();
final Copy copy = Copy();

class _ClassScreenState extends State<ClassScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
        animationDuration: const Duration(seconds: 1), length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  bool isLoading = false;
  final int classBadge = 0;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              toolbarHeight: 4,
              bottom: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue[900],
                indicatorWeight: 2,
                controller: tabController,
                tabs: const [
                  Tab(
                    text: 'Class',
                  ),
                  Tab(
                    text: 'Groups',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                widget.userType == 'Teacher'
                    ? TeacherClassStream(widget: widget, context: context)
                    : widget.userType == 'Student'
                        ? StudentJoinedClassStream(
                            widget: widget, context: context)
                        : const NoData(
                            noDataText: 'No room yet'
                                '...',
                          ),
                widget.userType == 'Teacher'
                    ? TeacherGroupStream(widget: widget, context: context)
                    : widget.userType == 'Student'
                        ? StudentJoinedGroupStream(
                            context: context, widget: widget)
                        : const NoData(
                            noDataText: 'No room yet'
                                '...',
                          ),
              ],
            ),
            floatingActionButton: SpeedDial(
              spaceBetweenChildren: 10,
              overlayColor: Colors.black54,
              backgroundColor: Colors.blue[900],
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                widget.userType == 'Student'
                    ? SpeedDialChild(
                        onTap: () {
                          openJoinDialog('Class', joinClassCodeController,
                              teacherClassUIDController);
                        },
                        child: const Icon(CupertinoIcons.device_laptop),
                        label: 'Join Class',
                        labelBackgroundColor: Colors.yellow,
                        backgroundColor: Colors.yellow)
                    : SpeedDialChild(
                        onTap: () {
                          setState(() {
                            classCodeController.text =
                                'C${const Uuid().v1().substring(0, 8)}';
                          });
                          openCreateClass();
                        },
                        child: const Icon(CupertinoIcons.add_circled_solid),
                        label: 'Create Class',
                        labelBackgroundColor: Colors.yellow,
                        backgroundColor: Colors.yellow),
                widget.userType == 'Teacher'
                    ? SpeedDialChild(
                        onTap: () {
                          setState(() {
                            groupCodeController.text =
                                'G${const Uuid().v1().substring(0, 8)}';
                          });
                          openCreateGroup();
                        },
                        child: const Icon(CupertinoIcons.person_add_solid),
                        label: 'Create Group',
                        labelBackgroundColor: Colors.yellow,
                        backgroundColor: Colors.yellow)
                    : SpeedDialChild(
                        onTap: () {
                          openJoinDialog("Group", joinGroupCodeController,
                              teacherGroupUIDController);
                        },
                        child: const Icon(CupertinoIcons.group),
                        label: 'Join Group',
                        labelBackgroundColor: Colors.yellow,
                        backgroundColor: Colors.yellow)
              ],
            ),
          );
  }

  Future<void> openJoinDialog(
          String roomType,
          TextEditingController codeController,
          TextEditingController teacherUIDController) =>
      showDialog(
          barrierDismissible: false,
          context: _scaffoldKey.currentContext!,
          builder: (context) => StreamBuilder<Object>(
              stream: null,
              builder: (context, snapshot) {
                return AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Join $roomType'),
                    ],
                  ),
                  content: Form(
                    key: _qrKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          validator: (value) => value!.length <= 4
                              ? '$roomType '
                                  'code usually 4+'
                                  ' chars long'
                              : null,
                          decoration:
                              InputDecoration(label: Text('$roomType Code')),
                          controller: codeController,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (value) => value!.length <= 7
                              ? 'Teacher userID '
                                  'usually 7+'
                                  ' chars long'
                              : null,
                          decoration: const InputDecoration(
                              label: Text('Teacher UID'),
                              hintText: 'Ask for your teacher UID',
                              border: OutlineInputBorder()),
                          controller: teacherUIDController,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton.icon(
                            onPressed: () async {
                              final data = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const QRScanner()));

                              if (!mounted) {
                                return;
                              }
                              Navigator.pop(context);
                              setState(() {
                                teacherUIDController.text =
                                    data.toString().split(",").last;
                                codeController.text =
                                    data.toString().split(",").first;
                              });
                              if (codeController.text[0] == 'C') {
                                roomType = "Class";
                              } else {
                                roomType = "Group";
                              }
                              openJoinDialog(roomType, codeController,
                                  teacherUIDController);
                            },
                            icon: const Icon(
                              Icons.qr_code,
                              color: Colors.black87,
                            ),
                            label: const Text(
                              'Join with QR Code',
                              style: TextStyle(color: Colors.black54),
                            ))
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton.icon(
                      onPressed: () {
                        codeController.text = '';
                        teacherUIDController.text = '';
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.class_),
                      label: const Text('Cancel'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        showError(roomType);
                        if (_qrKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          Navigator.pop(context);
                          final snapshot = roomReference
                              .doc(roomType)
                              .collection(teacherUIDController.text.trim())
                              .doc(codeController.text.trim());
                          await snapshot.get().then((value) {
                            var teacher = value['teacher'];
                            var roomName = value['name'];
                            joinReference
                                .doc(roomType)
                                .collection(widget.uid)
                                .doc(codeController.text.trim())
                                .set({
                              'userID': widget.uid,
                              'teacher': teacher,
                              'roomName': roomName,
                              'roomType': roomType,
                              'roomCode': codeController.text.trim(),
                              'teacherUID': teacherUIDController.text.trim()
                            }).whenComplete(() async {
                              Navigator.pop(context);
                              setState(() {
                                isLoading = false;
                              });
                              final PostService service = PostService();
                              await service.addToMember(
                                  roomType,
                                  teacherUIDController.text.trim(),
                                  codeController.text.trim(),
                                  widget.userName,
                                  widget.uid,
                                  widget.userType);
                              codeController.text = '';
                              teacherUIDController.text = '';
                              roomType == "Class"
                                  ? tabController.animateTo(0,
                                      duration: const Duration(seconds: 1))
                                  : tabController.animateTo(1,
                                      duration: const Duration(seconds: 1));
                            });
                          }).catchError((e) async {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            showError(roomType);
                          });
                        }
                      },
                      icon: const Icon(Icons.group),
                      label: Text('Join $roomType'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900]),
                    ),
                  ],
                );
              }));

  Future<void> openCreateClass() => showDialog(
      barrierDismissible: false,
      context: _scaffoldKey.currentContext!,
      builder: (context) => AlertDialog(
            title: const Text('Create Class'),
            content: Form(
              key: _qrKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (value) => value!.length < 5 || value.isEmpty
                        ? 'Ca'
                            'nno'
                            't be empty and chars must be 5+ long. '
                        : null,
                    controller: classNameController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(hintText: 'Class Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CupertinoTextField(
                    onTap: () async {
                      copy.showAndCopy(
                          'You copied ${classCodeController.text.trim()}',
                          classCodeController.text.trim(),
                          context,
                          mounted);
                    },
                    suffix: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.copy,
                        size: 15,
                      ),
                    ),
                    controller: classCodeController,
                    readOnly: true,
                    onSubmitted: (value) {},
                    keyboardType: TextInputType.visiblePassword,
                    padding: const EdgeInsets.all(10),
                    placeholder: 'Class code',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                icon: const Icon(Icons.class_),
                label: const Text('Create Class'),
                onPressed: () async {
                  final classInfo = Class(
                    classNameController.text.trim(),
                    classCodeController.text.trim(),
                    widget.userName,
                  );
                  if (_qrKey.currentState!.validate()) {
                    Navigator.pop(context);
                    setState(() {
                      isLoading = true;
                    });
                    createClass(classInfo);
                    final ClassService service = ClassService();
                    await service.switchRestriction("Class", widget.uid,
                        classCodeController.text.trim(), 'false');
                    final PostService add = PostService();
                    await add.addToMember(
                        'Class',
                        widget.uid,
                        classCodeController.text.trim(),
                        widget.userName,
                        widget.uid,
                        widget.userType);
                    if (!mounted) {
                      return;
                    }
                    copy.showAndCopy(
                        'You copied ${classCodeController.text.trim()}',
                        classCodeController.text.trim(),
                        context,
                        mounted);
                    setState(() {
                      isLoading = false;
                      classNameController.text = '';
                      tabController.animateTo(0,
                          duration: const Duration(seconds: 1));
                    });
                  }
                },
              )
            ],
          ));
  Future<void> openCreateGroup() => showDialog(
      barrierDismissible: false,
      context: _scaffoldKey.currentContext!,
      builder: (context) => AlertDialog(
            title: const Text('Create Group'),
            content: Form(
              key: _qrKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (value) => value!.length < 5 || value.isEmpty
                        ? 'Ca'
                            'nno'
                            't be empty and chars must be 5+ long. '
                        : null,
                    controller: groupNameController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: const InputDecoration(hintText: 'Group name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CupertinoTextField(
                    suffix: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.copy,
                        size: 15,
                      ),
                    ),
                    onTap: () => copy.showAndCopy(
                        'You copied ${groupCodeController.text.trim()}',
                        groupCodeController.text.trim(),
                        context,
                        mounted),
                    controller: groupCodeController,
                    readOnly: true,
                    onSubmitted: (value) {},
                    keyboardType: TextInputType.visiblePassword,
                    padding: const EdgeInsets.all(10),
                    placeholder: 'Group code',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                icon: const Icon(Icons.class_),
                label: const Text('Create Group'),
                onPressed: () async {
                  final groupInfo = Group(
                    groupNameController.text.trim(),
                    groupCodeController.text.trim(),
                    widget.userName,
                  );
                  if (_qrKey.currentState!.validate()) {
                    Navigator.pop(context);
                    setState(() {
                      isLoading = true;
                    });
                    createGroup(groupInfo);
                    final ClassService service = ClassService();
                    await service.switchRestriction("Group", widget.uid,
                        groupCodeController.text.trim(), 'false');
                    final PostService add = PostService();
                    await add.addToMember(
                        'Group',
                        widget.uid,
                        groupCodeController.text.trim(),
                        widget.userName,
                        widget.uid,
                        widget.userType);
                    if (!mounted) {
                      return;
                    }
                    copy.showAndCopy(
                        'You copied ${groupCodeController.text.trim()}',
                        groupCodeController.text.trim(),
                        context,
                        mounted);
                    setState(() {
                      isLoading = false;
                      groupNameController.text = '';
                      tabController.animateTo(1,
                          duration: const Duration(seconds: 1));
                    });
                  }
                },
              )
            ],
          ));

  //create
  Future createClass(Class classInfo) async {
    final docUser = FirebaseFirestore.instance
        .collection('Rooms')
        .doc('Class')
        .collection(widget.uid)
        .doc(classCodeController.text.trim());
    final json = classInfo.toJson();
    await docUser.set(json);
  }

  Future createGroup(Group groupInfo) async {
    final docUser = FirebaseFirestore.instance
        .collection('Rooms')
        .doc('Group')
        .collection(widget.uid)
        .doc(groupCodeController.text.trim());
    final json = groupInfo.toJson();
    await docUser.set(json);
  }

  Future showError(String roomType) => showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (context) => CupertinoAlertDialog(
            content: Column(
              children: [
                Lottie.asset('assets/no_room.json', width: 150),
                Text('$roomType not found or not a valid $roomType ID.')
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

  Future joinWithQR(String teacherUID, String roomCode) async {
    String roomType = '';
    if (roomCode[0] == "C") {
      roomType == 'Class';
    } else {
      roomType == 'Group';
    }
    try {
      roomReference.doc(roomType).collection(teacherUID).doc(roomCode).get();
    } on FirebaseException {
      showError(roomType);
    } finally {
      await roomReference
          .doc(roomType)
          .collection(teacherUID)
          .doc(roomCode)
          .get()
          .then((value) {
        var teacher = value['teacher'];
        var roomName = value['name'];

        joinReference.doc(roomType).collection(widget.uid).doc(roomCode).set({
          'userID': widget.uid,
          'teacher': teacher,
          'roomName': roomName,
          'roomType': roomType,
          'roomCode': roomCode,
          'teacherUID': teacherUID
        }).whenComplete(() {
          Navigator.pop(context);
          classCodeController.text = '';
          classNameController.text = '';
          groupCodeController.text = '';
          groupNameController.text = '';
          roomType == "Class"
              ? tabController.animateTo(0, duration: const Duration(seconds: 1))
              : tabController.animateTo(1,
                  duration: const Duration(seconds: 1));
        });
      });
    }
  }
}
