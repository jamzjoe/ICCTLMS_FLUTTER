import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:icct_lms/chat_room/chat_main.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/models/user_info.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserInfo>>(
      stream: readUser(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: data.map(buildListTileForStudent).toList(),
            ),
          );
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();

        }else{
          return const NoData();
        }

      }
    );
  }

  Stream <List<UserInfo>> readUser() => FirebaseFirestore.instance.collection
    ('Users').where('userType', isEqualTo: 'Student')
    .snapshots().map((snapshot) => snapshot.docs.map((e) => UserInfo
      .fromJson(e.data())).toList());

  Widget buildListTileForStudent(UserInfo e) => Card(
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: ListTile(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
              ChatMain(name: e.name, userID: widget.uid, receiverID:
              widget.uid,
                  userType: e.userType)));
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue[900],
          child: Center(
            child: Text(e.name.substring(0, 2).toUpperCase(), style: const
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),),
          ),
        ),
        title: Text(e.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(e.school),
            Text(e.userType)],
        ),
        trailing: const Icon(Icons.message_sharp),
      ),
    ),
  );
}
