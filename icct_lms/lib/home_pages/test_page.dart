import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.data}) : super(key: key);
  final String data;
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Boss Joe may nakuha tayong data sa QR CODe', style:
        TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),),
            Text(widget.data),
          ],
        ),
      ),
    );
  }
}
