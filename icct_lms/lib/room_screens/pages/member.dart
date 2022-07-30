import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/models/members_model.dart';

class Member extends StatefulWidget {
  const Member(
      {Key? key,
      required this.uid,
      required this.userType,
      required this.userName,
      required this.roomType, required this.roomCode, required this.teacher, required this.roomName, required this.teacherUID})
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
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MembersModel>?>(
      stream: getMembers(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final data = snapshot.data!;
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Expanded(child: ListView(
                    children: data.map(buildMemberTiles).toList(),
                  ))
                ],
              ),
            ),
          );
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        }
        else{
          return const NoData();
        }

      }
    );
  }

  Stream<List<MembersModel>>getMembers() => FirebaseFirestore.instance.collection
    ('Rooms').doc(widget.roomType).collection(widget.teacherUID).doc(widget
      .roomCode)
      .collection
    ('Members').orderBy('sortKey', descending: false).snapshots().map((event) =>
      event.docs.map((e) => MembersModel
      .fromJson(e.data())).toList());

  Widget buildMemberTiles(MembersModel e) => Card(
    color: e.userType == 'Teacher' ? Colors.blue[900] : Colors.white,
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: e.userType == 'Teacher' ? Colors.white : Colors
            .blue[900],
        child: Center(
          child: Text(e.name.substring(0,2).toUpperCase(), style:
           TextStyle(
            fontWeight: FontWeight.bold,
            color: e.userType == 'Teacher' ? Colors.black : Colors.white,
          ),),
        ),
      ),
      title: Text(e.name, style: TextStyle(
        color: e.userType == 'Teacher' ? Colors.white : Colors.black,
      ),),
      subtitle: Text(e.userType, style: TextStyle(
        color: e.userType == 'Teacher' ? Colors.white : Colors.black,
      ),),
      trailing: IconButton(
        onPressed: (){
          if(e.userType == 'Student'){
            showNotice(e.name, e.userID, e.userType);
          }else{
            if(widget.userType == 'Teacher'){
              showWarning();
            }
          }
        },
        icon: Icon(e.userType == 'Teacher' ? Icons.delete_forever : Icons.exit_to_app,
          color: e.userType == 'Teacher' ?
        Colors
            .white
            : Colors
            .black,),
      ),
    ),
  );

  Future showNotice(String name, String userID,  String userType) => showDialog
    (context: context,
      builder: (context) =>
  AlertDialog(
    title: const Text("Warning"),
    content: Text('Are you sure you want to remove $name from the ${widget.roomType}'),
    actions: [
      TextButton(onPressed: (){}, child: const Text('Okay')),
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: const Text('Cancel')),
    ],

  ));

  Future showWarning() =>showDialog
    (context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Warning"),
            content: Text('Are you sure you want to delete this ${widget.roomType}'),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              }, child: const Text('Okay')),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel')),
            ],

          ));
}
