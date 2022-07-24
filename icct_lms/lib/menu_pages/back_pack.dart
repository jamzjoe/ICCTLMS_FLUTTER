import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';

class BackPack extends StatefulWidget {
  const BackPack({Key? key}) : super(key: key);

  @override
  State<BackPack> createState() => _BackPackState();
}

class _BackPackState extends State<BackPack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: const Text('BackPack'),
        ),
        body: const NoData());
  }
}
