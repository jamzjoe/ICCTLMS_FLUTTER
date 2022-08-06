import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/components/not_found.dart';
import 'package:icct_lms/models/comment_model.dart';
import 'package:icct_lms/models/heart_model.dart';
import 'package:icct_lms/models/post_model.dart';
import 'package:icct_lms/services/comment.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Column(
        children: [
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Center(
                      child:
                          Text(widget.e.postName.substring(0, 2).toUpperCase()),
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
                                style: TextStyle(fontWeight: FontWeight.w300)),
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
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.e.message,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w300),
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
                      StreamBuilder<List<HeartModel>>(
                          stream: FirebaseFirestore.instance
                              .collection('Post')
                              .doc(widget.e.postID)
                              .collection('Heart')
                              .snapshots()
                              .map((event) => event.docs
                                  .map((e) => HeartModel.fromJson(e.data()))
                                  .toList()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
                              final heartCount = data.length;
                              return Flexible(
                                child: Row(
                                  children: [
                                    InkWell(
                                      focusColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      canRequestFocus: false,
                                      onLongPress: () async {
                                        await service.decrementHeart(
                                            widget.e.postID, widget.userID);
                                      },
                                      child: StreamBuilder<List<HeartModel>>(
                                          stream: FirebaseFirestore.instance
                                              .collection('Post')
                                              .doc(widget.e.postID)
                                              .collection('Heart')
                                              .where('userID',
                                                  whereIn: [widget.userID])
                                              .snapshots()
                                              .map((event) => event.docs
                                                  .map((e) =>
                                                      HeartModel.fromJson(
                                                          e.data()))
                                                  .toList()),
                                          builder: (context, joe) {
                                            if (joe.hasData) {
                                              final data = joe.data!;

                                              if (data.isEmpty) {
                                                return IconButton(
                                                  focusColor:
                                                      Colors.transparent,
                                                  splashColor:
                                                      Colors.transparent,
                                                  onPressed: () {
                                                    service.incrementHeart(
                                                        widget.e.postID,
                                                        widget.username,
                                                        widget.userID,
                                                        widget.userType,
                                                        'true');
                                                  },
                                                  icon: const Icon(
                                                      FontAwesomeIcons
                                                          .solidHeart,
                                                      color: Colors.grey),
                                                );
                                              }
                                              return IconButton(
                                                focusColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onPressed: () {
                                                  service.incrementHeart(
                                                      widget.e.postID,
                                                      widget.username,
                                                      widget.userID,
                                                      widget.userType,
                                                      'true');
                                                },
                                                icon: const Icon(
                                                    FontAwesomeIcons.solidHeart,
                                                    color: Colors.red),
                                              );
                                            } else {
                                              return IconButton(
                                                focusColor: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onPressed: () {
                                                  service.incrementHeart(
                                                      widget.e.postID,
                                                      widget.username,
                                                      widget.userID,
                                                      widget.userType,
                                                      'true');
                                                },
                                                icon: const Icon(
                                                    FontAwesomeIcons.solidHeart,
                                                    color: Colors.grey),
                                              );
                                            }
                                          }),
                                    ),
                                    Text(heartCount.toString())
                                  ],
                                ),
                              );
                            }
                            return Flexible(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      service.incrementHeart(
                                          widget.e.postID,
                                          widget.username,
                                          widget.userID,
                                          widget.userType,
                                          'true');
                                    },
                                    icon:
                                        const Icon(FontAwesomeIcons.solidHeart),
                                    color: Colors.grey,
                                  ),
                                  const Text('0')
                                ],
                              ),
                            );
                          }),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Post')
                              .doc(widget.e.postID)
                              .collection('Comment')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final commentCount = snapshot.data!.docs.length;
                              return Flexible(
                                  child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        myFocusNode.requestFocus();
                                      },
                                      icon: const Icon(
                                          FontAwesomeIcons.solidComment,
                                          color: Colors.grey)),
                                  Text(commentCount.toString())
                                ],
                              ));
                            }
                            return Flexible(
                                child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      FontAwesomeIcons.comment,
                                      color: Colors.grey.withOpacity(0.4),
                                    )),
                                const Text('0')
                              ],
                            ));
                          }),
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
          StreamBuilder<List<CommentModel>>(
              stream: readComments(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  if (data.length < 2) {
                    return Expanded(
                        child: ListView(
                      children: data.map(createCommentTiles).toList(),
                    ));
                  }
                  return Expanded(
                    child: ScrollablePositionedList.builder(
                      itemScrollController: itemController,
                      itemBuilder: (BuildContext context, int index) {
                        return data.map(createCommentTiles).toList()[index];
                      },
                      itemCount: data.length,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const NotFound(notFoundText: 'Something went wrong');
                } else {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              }),
          SizedBox(
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
        ],
      ),
    );
  }

  Future share(String message, String name) async {
    await Share.share('Post from $name \n $message');
  }

  Stream<List<CommentModel>> readComments() => FirebaseFirestore.instance
      .collection('Post')
      .doc(widget.e.postID)
      .collection('Comment')
      .orderBy('sortKey', descending: true)
      .snapshots()
      .map((event) =>
          event.docs.map((e) => CommentModel.fromJson(e.data())).toList());

  Widget createCommentTiles(CommentModel e) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Center(
                child: Text(e.name.substring(0, 2).toUpperCase()),
              ),
            ),
            title: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.name),
                    Text(
                      e.userType,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableLinkify(
                          options: const LinkifyOptions(humanize: true),
                          text: e.message,
                          onOpen: (link) async {
                            launch(link.url);
                          },
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 12),
                          linkStyle: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  void scrollToIndex(int index) => itemController.jumpTo(index: index);
}
