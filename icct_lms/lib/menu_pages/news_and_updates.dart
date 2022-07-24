import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';

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
        backgroundColor: Colors.blue[900],
        title: const Text('News and Updates'),
      ),
      body: const NoData(),
    );
  }
}
