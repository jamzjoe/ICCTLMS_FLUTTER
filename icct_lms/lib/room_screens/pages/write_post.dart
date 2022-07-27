import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icct_lms/services/post.dart';
import 'package:lottie/lottie.dart';

class WritePost extends StatefulWidget {
  const WritePost({
    Key? key,
    required this.uid,
    required this.userType,
    required this.userName,
    required this.roomType,
    required this.roomCode,
    required this.roomName,
    required this.teacherUID,
  }) : super(key: key);
  final String uid;
  final String userType;
  final String userName;
  final String roomType;
  final String roomCode;
  final String roomName;
  final String teacherUID;
  @override
  State<WritePost> createState() => _WritePostState();
}

final messageController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _WritePostState extends State<WritePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Create Post'),
      ),
      body: postTextField(widget: widget),
    );
  }
}

class postTextField extends StatefulWidget {
  const postTextField({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final WritePost widget;

  @override
  State<postTextField> createState() => _postTextFieldState();
}
bool error = false;
class _postTextFieldState extends State<postTextField> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: readRestrictions(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child:
                        Text(widget.widget.userName.substring(0, 2).toUpperCase()),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(widget.widget.userName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) => value!.length < 5
                      ? 'Cannot post less than'
                          ' 5 chars long.'
                      : null,
                  maxLines: null,
                  controller: messageController,
                  decoration: const InputDecoration(
                      label: Text('Post'),
                      hintText: 'Write Something...',
                      border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                      onPressed: () async {
                        final PostService post = PostService();
                        if (_formKey.currentState!.validate()) {
                          final data = snapshot.data!;
                          try {
                            data['restriction'];
                          }catch(e){
                            Navigator.pop(context);
                            await post.createPost(
                                widget.widget.roomType,
                                widget.widget.teacherUID,
                                widget.widget.roomCode,
                                messageController.text.trim(),
                                widget.widget.userName,
                                widget.widget.uid);

                            messageController.text = '';
                        }finally{
                            if(data['restriction'] == 'true'){
                                showError('Your teacher set '
                                    'the ${widget.widget.roomType} post to '
                                    'private.');
                                setState(() {
                                  messageController.text = '';
                                  error = true;
                                });
                            }else{

                              Navigator.pop(context);
                              await post.createPost(
                                  widget.widget.roomType,
                                  widget.widget.teacherUID,
                                  widget.widget.roomCode,
                                  messageController.text.trim(),
                                  widget.widget.userName,
                                  widget.widget.uid);

                              messageController.text ='';
                            }
                          }
                        }
                      },
                      child: const Text('Post'))
                ],
              )
            ],
          ),
        );
      }
    );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> readRestrictions() =>
      FirebaseFirestore.instance
          .collection('Rooms')
          .doc(widget.widget.roomType)
          .collection(widget.widget.teacherUID)
          .doc(widget.widget.roomCode)
          .snapshots();

  Future showError(String errorMessage) => showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Column(
          children: [
            Lottie.asset('assets/error.json', width: 150),
            Text(errorMessage)
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'))
        ],
      ));
}
