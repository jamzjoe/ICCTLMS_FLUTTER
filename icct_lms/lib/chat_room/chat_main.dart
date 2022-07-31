import 'package:flutter/material.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({Key? key, required this.name, required this.userID, required this.receiverID, required this.userType}) : super(key: key);
  final String name;
  final String userID;
  final String userType;
  final String receiverID;
  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CircleAvatar(
            backgroundColor: Colors.blue[900],
            child: Center(
              child: Text(widget.name.substring(0,2).toUpperCase(), style:
              const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        title: Text('${widget.name} - ${widget.userType}', style:const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w400
        ),),
      ),
      body: Center(
        child: ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons
            .chat),
            label: const Text('Start conversation'), style: ElevatedButton.styleFrom(
            primary: Colors.blue[900]
          ),),
      ),
    );
  }
}
