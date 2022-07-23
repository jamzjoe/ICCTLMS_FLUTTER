import 'package:flutter/material.dart';
import 'package:icct_lms/components/nodata.dart';

class Folder extends StatefulWidget {
  const Folder(
      {Key? key,
      required this.uid,
      required this.userType,
      required this.userName,
      required this.roomType})
      : super(key: key);
  final String uid;
  final String userType;
  final String userName;
  final String roomType;
  @override
  State<Folder> createState() => _FolderState();
}

class _FolderState extends State<Folder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.roomType} Sources',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const NoData()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
