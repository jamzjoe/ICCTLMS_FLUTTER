import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_4.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/chat_room/chat_main.dart';
import 'package:icct_lms/components/chat_empty.dart';
import 'package:icct_lms/components/something_wrong.dart';
import 'package:icct_lms/models/chat_model.dart';

class ChatStream extends StatefulWidget {
  const ChatStream({Key? key, required this.context, required this.widget,
    required this.formKey}) : super(key: key);
  final BuildContext context;
  final ChatMain widget;
  final GlobalKey<FormState> formKey;

  @override
  State<ChatStream> createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<List<ChatModel>?>(
              stream: readChat(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  if (data.isEmpty) {
                    return const ChatLoad();
                  }
                  return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          reverse: true,
                          children: data.map(buildChatTiles).toList(),
                        ),
                      ));
                } else if (snapshot.hasError) {
                  return const SomethingWrong();
                } else {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [CupertinoActivityIndicator()],
                    ),
                  );
                }
              }),
          Container(
              padding: const EdgeInsets.only(
                  top: 0, right: 10, left: 10, bottom: 5),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white60,
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  child: Form(
                    key: widget.formKey,
                    child: TextFormField(
                      autofocus: true,
                      validator: (value) => value!.isEmpty
                          ? "Can't send empty "
                          "message!"
                          : null,
                      controller: chatController,
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: null,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () async {
                              if (widget.formKey.currentState!.validate()) {
                                await service.sendChat(
                                    widget.widget.userType == 'Teacher'
                                        ? widget.widget.userID
                                        : widget.widget.clickID,
                                    widget.widget.userType == 'Student'
                                        ? widget.widget.userID
                                        : widget.widget.clickID,
                                    widget.widget.userName,
                                    widget.widget.userID,
                                    widget.widget.userType,
                                    chatController.text.trim());
                              }

                              setState(() {
                                chatController.text = '';
                              });
                            },
                            icon: const Icon(
                                FontAwesomeIcons.paperPlane)),
                        hintText: "Type your message here...",
                        border: InputBorder.none,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ))
        ]);
  }

  Widget buildChatTiles(ChatModel e) => Padding(
    padding: const EdgeInsets.all(3.0),
    child: InkWell(
      onDoubleTap: () => setState(() {
        isVisible = !isVisible;
      }),
      onTap: () => setState(() {
        showDate = !showDate;
      }),
      onLongPress: () async {
        HapticFeedback.vibrate();
        if (e.userID == widget.widget.userID) {
          await showOptions(e);
        }
      },
      child: Column(
        children: [
          Visibility(
            visible: widget.widget.userID != e.userID && isVisible,
            child: Align(
                alignment: e.userID == widget.widget.userID
                    ? Alignment.center
                    : Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '${e.date}, ${e.hour} ',
                      style: const TextStyle(fontSize: 12),
                    ))),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Visibility(
                  visible: e.userID != widget.widget.userID,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[900],
                    child: Center(
                      child: Text(
                        e.name.substring(0, 2).toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )),
              Expanded(
                child: GestureDetector(
                  child: ChatBubble(
                    elevation: 2,
                    backGroundColor: e.userID == widget.widget.userID
                        ? Colors.blue
                        : Colors.white,
                    alignment: e.userID == widget.widget.userID
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    clipper: ChatBubbleClipper4(
                        type: e.userID != widget.widget.userID
                            ? BubbleType.receiverBubble
                            : BubbleType.sendBubble),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: e.userID == widget.widget.userID
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Visibility(
                              visible: e.userID != widget.widget.userID,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${e.name} - ${e.hour}',
                                    style: const TextStyle(
                                        color: Colors.black45),
                                  ),
                                  Text(
                                    e.userType,
                                    style: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 10),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  )
                                ],
                              )),
                          Column(
                            crossAxisAlignment: widget.widget.userID == e.userID
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.message,
                                style: TextStyle(
                                    color: e.userID == widget.widget.userID
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              if (e.userID == widget.widget.userID && showDate)
                                Text(
                                  '${e.date}, ${e.hour}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: widget.widget.userID == e.userID && isVisible,
            child: Align(
                alignment: e.userID == widget.widget.userID
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Delivered',
                      style: TextStyle(fontSize: 12),
                    ))),
          ),
          Visibility(
            visible: widget.widget.userID != e.userID && isVisible,
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Seen',
                      style: TextStyle(fontSize: 12),
                    ))),
          ),
        ],
      ),
    ),
  );

  Stream<List<ChatModel>?> readChat() => FirebaseFirestore.instance
      .collection('Chat')
      .doc(widget.widget.userType == 'Teacher' ? widget.widget.userID : widget.widget.clickID)
      .collection(widget.widget.userType == 'Student' ? widget.widget.userID : widget.widget.clickID)
      .orderBy('sortKey', descending: true)
      .snapshots()
      .map((event) =>
      event.docs.map((e) => ChatModel.fromJson(e.data())).toList());

  Future showOptions(ChatModel e) => showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Warning'),
        content: const Text('Delete this message?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (widget.widget.userID == e.userID) {
                await service.deleteMessage(
                    widget.widget.userType == 'Teacher'
                        ? widget.widget.userID
                        : widget.widget.clickID,
                    widget.widget.userType == 'Student'
                        ? widget.widget.userID
                        : widget.widget.clickID,
                    e.chatID);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ));
}
