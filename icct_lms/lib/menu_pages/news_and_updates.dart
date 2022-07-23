import 'package:flutter/material.dart';

class NewsUpdates extends StatefulWidget {
  const NewsUpdates({Key? key}) : super(key: key);

  @override
  State<NewsUpdates> createState() => _NewsUpdatesState();
}

class _NewsUpdatesState extends State<NewsUpdates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News and Updates'),
      ),
    );
  }
}
