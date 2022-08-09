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

bool noData = true;

class _FolderState extends State<Folder> {
  @override
  Widget build(BuildContext context) {
    return noData
        ? Scaffold(
            body: Center(
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900]),
                  onPressed: () {},
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload files')),
            ),
          )
        : Scaffold(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          NoData(
                            noDataText: 'No data yet...',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
