import 'package:flutter/material.dart';

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
        title: Text('BackPack'),
      ),
    );
  }
}
