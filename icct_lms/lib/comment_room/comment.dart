import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icct_lms/components/not_found.dart';
import 'package:icct_lms/models/comment_model.dart';
import 'package:icct_lms/models/post_model.dart';
import 'package:icct_lms/services/comment.dart';
import 'package:share_plus/share_plus.dart';

class Comment extends StatefulWidget {
  const Comment({
    Key? key,
    required this.e, required this.username, required this.userID, required this.userType,
  }) : super(key: key);
  final PostModel e;
  final String username;
  final String userID;
  final String userType;
  @override
  State<Comment> createState() => _CommentState();
}

final _formKey = GlobalKey<FormState>();
final commentController = TextEditingController();
class _CommentState extends State<Comment> {
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
                      child: Text(widget.e.postName.substring(0, 2).toUpperCase()),
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
                                recognizer: TapGestureRecognizer()..onTap = () {})
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
                          style: const TextStyle(color: Colors.black54),
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
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.solidHeart),
                        color: Colors.grey,
                      ),
                      IconButton(
                        onPressed: () async {},
                        icon: const Icon(FontAwesomeIcons.solidComment),
                        color: Colors.grey,
                      ),
                      IconButton(
                        onPressed: () {
                          share(widget.e.message, widget.e.postName);
                        },
                        icon: const Icon(FontAwesomeIcons.shareNodes),
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),

          StreamBuilder<List<CommentModel>>(
            stream: readComments(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                final data = snapshot.data!;
                return Expanded(
                  child: ListView(
                    children: data.map(createCommentTiles).toList(),
                  ),
                );
              }else if(snapshot.hasError){
                return const NotFound(notFoundText: 'Something went wrong');
              }else{
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

            }
          )
          
        ],
      ),

      bottomSheet: Container(
        width: double.infinity,
        child: Card(
          child: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) => value!.isEmpty ? "Can't send empty "
                  "comment" : null,
              controller: commentController,
              decoration: InputDecoration(
                suffixIcon: IconButton(onPressed: ()async{
                  if(_formKey.currentState!.validate()){

                      final CommentService service = CommentService();
                      await service.createComment(widget.e.postID,
                          commentController.text.trim(), widget.username,
                          widget.userID, widget.userType);
                      commentController.text = '';

                  }
                }, icon: Icon(FontAwesomeIcons.paperPlane)),
                label: Text('Comment'),
                hintText: 'Type your comment...',
                border: OutlineInputBorder()
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future share(String message, String name) async {
    await Share.share('Post from $name \n $message');
  }

  Stream<List<CommentModel>> readComments() => FirebaseFirestore.instance
      .collection
    ('Post').doc
    (widget.e.postID).collection('Comment').snapshots().map((event) => event
      .docs.map((e) => CommentModel.fromJson(e.data())).toList());

  Widget createCommentTiles(CommentModel e) => Card(
    child: Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            child: Center(
              child: Text(e.name.substring(0, 2).toUpperCase()),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e.name),
              Text(
               e.userType,
                style: const TextStyle(
                    fontWeight: FontWeight.w300, fontSize: 12),
              ),
              Text(
                '${e.date} ${e.hour}',
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
                  e.message,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

}
