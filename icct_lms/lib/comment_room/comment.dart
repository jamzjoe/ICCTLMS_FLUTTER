import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/comment_room/streams/comment_count_stream.dart';
import 'package:icct_lms/comment_room/streams/comment_streams.dart';
import 'package:icct_lms/comment_room/streams/heart_stream.dart';
import 'package:icct_lms/models/post_model.dart';
import 'package:icct_lms/services/comment.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

class Comment extends StatefulWidget {
  const Comment({
    Key? key,
    required this.e,
    required this.username,
    required this.userID,
    required this.userType,
  }) : super(key: key);
  final PostModel e;
  final String username;
  final String userID;
  final String userType;
  @override
  State<Comment> createState() => _CommentState();
}

late FocusNode myFocusNode;
final _formKey = GlobalKey<FormState>();
final commentController = TextEditingController();
final itemController = ItemScrollController();
final CommentService service = CommentService();

class _CommentState extends State<Comment> {
  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Comment'),
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        child: Card(
          child: Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              validator: (value) => value!.isEmpty
                  ? "Can't send empty "
                      "comment"
                  : null,
              controller: commentController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            WidgetsBinding.instance.addPostFrameCallback(
                                (timeStamp) => scrollToIndex(0));
                          });

                          final CommentService service = CommentService();
                          await service.createComment(
                              widget.e.postID,
                              commentController.text.trim(),
                              widget.username,
                              widget.userID,
                              widget.userType);
                          commentController.text = '';
                        }
                      },
                      icon: const Icon(FontAwesomeIcons.paperPlane)),
                  label: const Text('Comment'),
                  hintText: 'Type your comment...',
                  border: const OutlineInputBorder()),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Center(
                          child: Text(
                              widget.e.postName.substring(0, 2).toUpperCase()),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                TextSpan(text: widget.e.postName),
                                const TextSpan(
                                    text: ' posted from ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: widget.e.roomName,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {})
                              ])),
                          Text(
                            widget.e.userType,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          Text(
                            '${widget.e.date} ${widget.e.hour}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.grey.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.e.message,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HeartStreams(widget: widget),
                          CommentCountStream(widget: widget),
                          Flexible(
                            child: IconButton(
                              onPressed: () {
                                share(widget.e.message, widget.e.postName);
                              },
                              icon: const Icon(FontAwesomeIcons.shareNodes),
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              CommentStream(widget: widget)
            ],
          ),
        ),
      ),
    );
  }

  Future share(String message, String name) async {
    await Share.share('Post from $name \n $message');
  }

  void scrollToIndex(int index) => itemController.jumpTo(index: index);
}
