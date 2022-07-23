import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(widget.uid),
        ),
      ),
    );
  }
}
