import 'package:flutter/material.dart';

class Parent extends StatefulWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  State<Parent> createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Main'),
      ),
    );
  }
}
