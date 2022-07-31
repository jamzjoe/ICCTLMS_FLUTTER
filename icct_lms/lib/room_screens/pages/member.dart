import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/chat_room/chat_main.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/models/members_model.dart';
import 'package:icct_lms/services/class_service.dart';
import 'package:icct_lms/services/join.dart';

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
      trailing: widget.userType == 'Student' && widget.uid != e.userID ?
        PopupMenuButton
        (
            icon: const Icon(FontAwesomeIcons.message, color: Colors.white,),
            itemBuilder:
          (context) =>
      [
        PopupMenuItem(
            onTap: ()async{
              await Future.delayed( const Duration(milliseconds: 500));
              startConversation(e.userID, e.userType, e.name);
            },
            child: const Text('Chat'))
      ]
      ): widget.userType == "Student" ? PopupMenuButton(itemBuilder: (context)
      => [
        PopupMenuItem(
            onTap: ()async{
            await Future.delayed(const Duration(milliseconds: 500));
            showNotice(e.name, e.userID, e.userType);
            },
            child: const Text('Leave room'))

      ]) : widget.userType == 'Teacher' && widget.uid != e.userID ? PopupMenuButton
        (itemBuilder:
        (context)=>
      [
        PopupMenuItem(
            onTap: ()async{
              await Future.delayed( const Duration(milliseconds: 500));
              startConversation(e.userID, e.userType, e.name);
            },
            child: const Text('Chat')),
        PopupMenuItem(
            onTap: ()async{
              await Future.delayed(const Duration(milliseconds: 500));
              showNotice(e.name, e.userID, e.userType);
            },
            child:const Text('Remove Student'))
      ]) : PopupMenuButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.white,),
          itemBuilder: (context) => [
        PopupMenuItem(
            onTap: ()async{
              await Future.delayed(const Duration(milliseconds: 500));
              showWarning();
              },
            child:const Text('Remove Room'))
      ])
    )
  );

  Future showNotice(String name, String userID,  String userType) => showDialog
    (context: context,
      builder: (context) =>
  AlertDialog(
    title: const Text("Warning"),
    content: widget.userType == 'Teacher' ? Text('Are you sure you want to '
        'remove '
        '$name in this ${widget.roomType}?' )
        : Text('Are you sure you want to leave in this ${widget.roomType}?'),
    actions: [
      TextButton(onPressed: ()async{
        if(widget.userType == "Teacher"){
          Navigator.pop(context);
        }else{
          Navigator.pop(context);
          Navigator.pop(context);
        }
        final Joined join = Joined(uid: widget.uid);
        await join.deleteJoin(widget.roomType, widget.roomCode, userID, widget
            .teacherUID);
      }, child: const Text('Okay')),
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
            content: Text('Are you sure you want to remove this ${widget
                .roomType}?'),
            actions: [
              TextButton(onPressed: ()async{
                final ClassService service = ClassService();
                Navigator.pop(context);
                Navigator.pop(context);
                await service.deleteRoom(widget.roomType, widget.uid,
                    widget.roomCode);
              }, child: const Text('Okay')),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel')),
            ],

          ));

  Future startConversation(String userID, String userType, String name)async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMain
      (name: name, userID: widget.uid, receiverID: userID, userType:
    userType)));
  }
}
