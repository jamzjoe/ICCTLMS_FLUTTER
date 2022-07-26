import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icct_lms/components/copy.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/home_pages/profile.dart';
import 'package:icct_lms/models/class_model.dart';
import 'package:icct_lms/models/group_model.dart';
import 'package:icct_lms/models/joined_model.dart';
import 'package:icct_lms/room_screens/room.dart';
import 'package:icct_lms/services/join.dart';
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
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final _formKey = GlobalKey<FormState>();
final Copy copy = Copy();
final _classKey = GlobalKey<FormState>();
final _groupKey = GlobalKey<FormState>();

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

  final Joined join = Joined(uid: uid);
  final int classBadge = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              text: 'Classes',
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
              ? StreamBuilder<List<Class>?>(
                  stream: readClass(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    } else if (snapshot.hasData) {
                      final classes = snapshot.data!;

                      if (classes.isEmpty) {
                        return const NoData();
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
                  })
              : widget.userType == 'Student'
                  ? StreamBuilder<List<JoinedModel>?>(
                      stream: readJoinedClass(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        } else if (snapshot.hasData) {
                          final classes = snapshot.data!;

                          if (classes.isEmpty) {
                            return const NoData();
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
                      })
                  : const NoData(),
          widget.userType == 'Teacher'
              ? StreamBuilder<List<Group>?>(
                  stream: readGroup(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    } else if (snapshot.hasData) {
                      final group = snapshot.data!;

                      if (group.isEmpty) {
                        return const NoData();
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
                  })
              : widget.userType == 'Student'
                  ? StreamBuilder<List<JoinedModel>?>(
                      stream: readJoinGroup(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        } else if (snapshot.hasData) {
                          final classes = snapshot.data!;

                          if (classes.isEmpty) {
                            return const NoData();
                          }
                          return ListView(
                            children: classes.map(buildGroupList).toList(),
                          );
                        } else {
                          return Center(
                            child: SpinKitFadingCircle(
                              color: Colors.blue[900],
                            ),
                          );
                        }
                      })
                  : const NoData(),
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
                      Text(
                        "If this dialog doesn't close automatically it means no $roomType found or wrong inputs.",
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  content: Form(
                    key: _formKey,
                    child: Column(
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
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          codeController.text = '';
                          teacherUIDController.text = '';
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              roomReference
                                  .doc(roomType)
                                  .collection(teacherUIDController.text.trim())
                                  .doc(codeController.text.trim())
                                  .get();
                            } on FirebaseException {
                              showError(roomType);
                            } finally {
                              roomReference
                                  .doc(roomType)
                                  .collection(teacherUIDController.text.trim())
                                  .doc(codeController.text.trim())
                                  .get()
                                  .then((value) {
                                var teacher = value['teacher'];
                                var roomName = value['name'];

                                joinReference
                                    .doc(roomType)
                                    .collection(uid)
                                    .doc(codeController.text.trim())
                                    .set({
                                  'userID': uid,
                                  'teacher': teacher,
                                  'roomName': roomName,
                                  'roomType': roomType,
                                  'roomCode': codeController.text.trim(),
                                  'teacherUID': teacherUIDController.text.trim()
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                  codeController.text = '';
                                  teacherUIDController.text = '';
                                  roomType == "Class"
                                      ? tabController.animateTo(0,
                                          duration: const Duration(seconds: 1))
                                      : tabController.animateTo(1,
                                          duration: const Duration(seconds: 1));
                                });
                              });
                            }
                          }
                        },
                        child: Text('Join $roomType')),
                  ],
                );
              }));

  Future<void> openCreateClass() => showDialog(
      barrierDismissible: false,
      context: _scaffoldKey.currentContext!,
      builder: (context) => AlertDialog(
            title: const Text('Create Class'),
            content: Form(
              key: _classKey,
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
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final classInfo = Class(classNameController.text.trim(),
                        classCodeController.text.trim(), widget.userName);
                    if (_classKey.currentState!.validate()) {
                      createClass(classInfo);
                      copy.showAndCopy(
                          'You copied ${classCodeController.text.trim()}',
                          classCodeController.text.trim(),
                          context,
                          mounted);
                      setState(() {
                        classNameController.text = '';
                        tabController.animateTo(0,
                            duration: const Duration(seconds: 1));
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create Class'))
            ],
          ));
  Future<void> openCreateGroup() => showDialog(
      barrierDismissible: false,
      context: _scaffoldKey.currentContext!,
      builder: (context) => AlertDialog(
            title: const Text('Create Group'),
            content: Form(
              key: _groupKey,
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
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final groupInfo = Group(groupNameController.text.trim(),
                        groupCodeController.text.trim(), widget.userName);
                    if (_groupKey.currentState!.validate()) {
                      createGroup(groupInfo);
                      copy.showAndCopy(
                          'You copied ${groupCodeController.text.trim()}',
                          groupCodeController.text.trim(),
                          context,
                          mounted);
                      setState(() {
                        groupNameController.text = '';
                        tabController.animateTo(1,
                            duration: const Duration(seconds: 1));
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create Group'))
            ],
          ));

  //streams
  Stream<List<Class>> readClass() => FirebaseFirestore.instance
      .collection('Rooms')
      .doc('Class')
      .collection(widget.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Class.fromJson(doc.data())).toList());
  Stream<List<Group>> readGroup() => FirebaseFirestore.instance
      .collection('Rooms')
      .doc('Group')
      .collection(widget.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());
  Stream<List<JoinedModel>> readJoinedClass() => FirebaseFirestore.instance
      .collection('Joined')
      .doc('Class')
      .collection(widget.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => JoinedModel.fromJson(doc.data()))
          .toList());
  Stream<List<JoinedModel>> readJoinGroup() => FirebaseFirestore.instance
      .collection('Joined')
      .doc('Group')
      .collection(widget.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => JoinedModel.fromJson(doc.data()))
          .toList());

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

  Widget buildGroup(Group e) => Card(
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Room(
                      uid: uid,
                      teacherUID: uid,
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
                onTap: () {
                  final docUser = FirebaseFirestore.instance
                      .collection('Rooms')
                      .doc('Group')
                      .collection(widget.uid)
                      .doc(e.code);
                  docUser.delete();
                },
                child: const Text('Delete'),
              )
            ],
          ),
        ),
      );
  Widget buildUser(Class e) => Card(
        child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Room(
                        uid: uid,
                        userName: widget.userName,
                        teacherUID: uid,
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
                  onTap: () {
                    final docUser = FirebaseFirestore.instance
                        .collection('Rooms')
                        .doc('Class')
                        .collection(widget.uid)
                        .doc(e.code.trim());
                    docUser.delete();
                  },
                  child: const Text('Delete'),
                )
              ],
            )),
      );

  Widget buildClassList(JoinedModel e) => Card(
        child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Room(
                        uid: uid,
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
                    join.deleteJoin(e.roomType, e.roomCode, e.userID);
                  },
                  child: Text('Leave ${e.roomType}'),
                )
              ],
            )),
      );

  Widget buildGroupList(JoinedModel e) => Card(
        child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Room(
                        uid: uid,
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
              backgroundColor: Colors.redAccent,
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
                    join.deleteJoin(e.roomType, e.roomCode, e.userID);
                  },
                  child: Text('Leave ${e.roomType}'),
                )
              ],
            )),
      );

  Future showError(String roomType) => showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
            content: Column(
              children: [
                Lottie.asset('assets/not.json', width: 150),
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
}
