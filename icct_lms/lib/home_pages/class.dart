import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen( {Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  var joinCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Class'),
            Text(widget.uid)
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        spaceBetweenChildren: 10,
        overlayColor: Colors.black54,
        backgroundColor: Colors.blue[900],
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            onTap: (){
              openJoinClassDialog();
            },
              child: const Icon(CupertinoIcons.device_laptop),
              label: 'Join Class',
              labelBackgroundColor: Colors.yellow,
              backgroundColor: Colors.yellow),
          SpeedDialChild(
            onTap: (){
              openCreateClass();
            },
              child: const Icon(CupertinoIcons.add_circled_solid),
              label: 'Create Class',
              labelBackgroundColor: Colors.yellow,
              backgroundColor: Colors.yellow),
          SpeedDialChild(
            onTap: (){
              openCreateGroup();
            },
              child: const Icon(CupertinoIcons.person_add_solid),
              label: 'Create Group',
              labelBackgroundColor: Colors.yellow,
              backgroundColor: Colors.yellow),
          SpeedDialChild(
            onTap: (){
              openJoinGroupDialog();
            },
              child: const Icon(CupertinoIcons.group),
              label: 'Join Group',
              labelBackgroundColor: Colors.yellow,
              backgroundColor: Colors.yellow)
        ],
      ),
    );
  }

  Future <void> openJoinClassDialog() => showDialog(context: context,
  builder: (context) => CupertinoAlertDialog(
    title: const Text('Join Class'),
    content: CupertinoTextField(
      onSubmitted: (value){
        setState(() {
          joinCode = value;
        });
      },
      keyboardType: TextInputType.visiblePassword,
      padding: const EdgeInsets.all(10),
      placeholder: 'Enter or paste class code', style: const TextStyle(
      fontSize: 14,
    ),
    ),
    actions: [
      TextButton(onPressed: (){
        Navigator.pop(context);
      }, child: const Text('Submit'))
    ],
  )
  );
  Future <void> openJoinGroupDialog() => showDialog(context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Join Group'),
        content: CupertinoTextField(
          onSubmitted: (value){
            setState(() {
              joinCode = value;
            });
          },
          keyboardType: TextInputType.visiblePassword,
          padding: const EdgeInsets.all(10),
          placeholder: 'Enter or paste group code', style: const TextStyle(
          fontSize: 14,
        ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('Submit'))
        ],
      )
  );
  Future <void> openCreateClass() => showDialog(context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Create Class'),
        content: Column(
          children: [
            CupertinoTextField(
              onSubmitted: (value){
                setState(() {
                  joinCode = value;
                });
              },
              keyboardType: TextInputType.visiblePassword,
              padding: const EdgeInsets.all(10),
              placeholder: 'Class name', style: const TextStyle(
              fontSize: 14,
            ),
            ),
            const SizedBox(height: 10,),
            CupertinoTextField(
              onSubmitted: (value){
                setState(() {
                  joinCode = value;
                });
              },
              keyboardType: TextInputType.visiblePassword,
              padding: const EdgeInsets.all(10),
              placeholder: 'Class code', style: const TextStyle(
              fontSize: 14,
            ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('Submit'))
        ],
      )
  );
  Future <void> openCreateGroup() => showDialog(context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Create Group'),
        content: Column(
          children: [
            CupertinoTextField(
              onSubmitted: (value){
                setState(() {
                  joinCode = value;
                });
              },
              keyboardType: TextInputType.visiblePassword,
              padding: const EdgeInsets.all(10),
              placeholder: 'Group name', style: const TextStyle(
              fontSize: 14,
            ),
            ),
            const SizedBox(height: 10,),
            CupertinoTextField(
              onSubmitted: (value){
                setState(() {
                  joinCode = value;
                });
              },
              keyboardType: TextInputType.visiblePassword,
              padding: const EdgeInsets.all(10),
              placeholder: 'Group code', style: const TextStyle(
              fontSize: 14,
            ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('Submit'))
        ],
      )
  );
}
