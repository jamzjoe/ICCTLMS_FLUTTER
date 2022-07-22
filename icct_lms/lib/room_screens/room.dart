import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/room_screens/pages/folder.dart';
import 'package:icct_lms/room_screens/pages/member.dart';
import 'package:icct_lms/room_screens/pages/post.dart';

class Room extends StatefulWidget {
  const Room({Key? key, required this.uid, required this.teacherUID, required this.teacher, required this.roomName, required this.roomType}) : super(key: key);
  final String uid;
  final String teacherUID;
  final String teacher;
  final String roomName;
  final String roomType;
  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
 @override
  void initState() {
    // TODO: implement initState
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
          title: Text('${widget.roomName} - ${widget.roomType}', style:
          const TextStyle
            (
            color: Colors.white
          ),),
          actions: [
            Builder(
              builder: (BuildContext context){
                return IconButton(onPressed: (){
                }, icon: const Icon(Icons.add_to_photos_sharp, color:
                Colors.white,));
              },
            ),
            Builder(
              builder: (BuildContext context){
                return IconButton(onPressed: (){

                }, icon: const Icon(Icons.video_call, color: Colors.white ,)
                );
              },
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue[900],
            indicatorWeight: 2,
            tabs: const [
              Tab(text: 'Timeline', icon: Icon(Icons.post_add),),
              Tab(text: 'Sources', icon: Icon(Icons.folder),),
              Tab(text: 'Members', icon: Icon(Icons.group),),
            ],

          ),
        ),
        body: TabBarView(
          children: [
            Post(uid: widget.uid, userType: widget.roomType, userName: widget.teacher,
            roomType: widget.roomType),
            Folder(uid: widget.uid, userType: widget.roomType, userName: widget.teacher,
                roomType: widget.roomType),
            Member(uid: widget.uid, userType: widget.roomType, userName: widget.teacher,
                roomType: widget.roomType),
          ],),
      ),
    );
  }
}
