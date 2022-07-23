import 'package:flutter/material.dart';

class WritePost extends StatefulWidget {
  const WritePost({
    Key? key,
    required this.uid,
    required this.userType,
    required this.userName,
    required this.roomType,
  }) : super(key: key);
  final String uid;
  final String userType;
  final String userName;
  final String roomType;
  @override
  State<WritePost> createState() => _WritePostState();
}

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
                child: Text(widget.userName.substring(0, 2)),
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
          const TextField(
            maxLines: null,
            decoration: InputDecoration(
                label: Text('Post'),
                hintText: 'Write Something...',
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue[900]),
                  onPressed: () {},
                  child: const Text('Post'))
            ],
          )
        ],
      ),
    );
  }
}
