import 'package:flutter/material.dart';
import 'package:icct_lms/services/post.dart';

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

class postTextField extends StatelessWidget {
  const postTextField({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final WritePost widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(widget.userName.substring(0, 2).toUpperCase()),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(widget.userName,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: TextField(
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
                    final Post post = Post();
                    try {
                      await post.createPost(
                          widget.roomType,
                          widget.teacherUID,
                          widget.roomCode,
                          messageController.text.trim(),
                          widget.userName,
                          widget.uid);
                    } catch (e) {
                      Navigator.pop(context);
                    } finally {
                      messageController.text = '';
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Post'))
            ],
          )
        ],
      ),
    );
  }
}
