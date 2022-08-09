import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/chat_room/streams/chatStream.dart';
import 'package:icct_lms/services/chat.dart';

class ChatMain extends StatefulWidget {
  const ChatMain(
      {Key? key,
      required this.clickName,
      required this.userID,
      required this.clickID,
      required this.userType,
      required this.clickUserType,
      required this.userName,
      required this.badgeChange})
      : super(key: key);
  final String clickName;
  final String userName;
  final String clickUserType;
  final String userID;
  final String userType;
  final String clickID;
  final Function badgeChange;
  @override
  State<ChatMain> createState() => _ChatMainState();
}

final chatController = TextEditingController();
final _formKey = GlobalKey<FormState>();
final ChatService service = ChatService();
bool isVisible = false;
bool showDate = false;

class _ChatMainState extends State<ChatMain> {
  bool loading = true;
  Future chatSplash() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    chatSplash();
    super.initState();
  }

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
                child: Text(
                  widget.clickName.substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.clickName,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
              Text(widget.clickUserType,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w300))
            ],
          ),
        ),
        body: loading
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : ChatStream(context: context, widget: widget, formKey: _formKey));
  }

  Future checkChanges() async {
    FirebaseFirestore.instance
        .collection('Chat')
        .doc(widget.userType == 'Teacher' ? widget.userID : widget.clickID)
        .collection(
            widget.userType == 'Student' ? widget.userID : widget.clickID)
        .orderBy('sortKey', descending: true)
        .snapshots()
        .listen((event) {
      event.docChanges.map((element) {
        widget.badgeChange;
      });
    });
  }
}
