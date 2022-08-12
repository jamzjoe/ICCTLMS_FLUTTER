import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icct_lms/chat_room/chat_main.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/components/not_found.dart';
import 'package:icct_lms/models/user_info.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen(
      {Key? key,
      required this.uid,
      required this.userType,
      required this.userName,
      required this.userEmail,
      required this.userCampus})
      : super(key: key);
  final String uid;
  final String userType;
  final String userName;
  final String userEmail;
  final String userCampus;
  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

final _searchController = TextEditingController();

class _MessageScreenState extends State<MessageScreen> {
  int badgeCount = 0;
  List<UserInfo> userData = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserInfo>>(
        stream: readUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isEmpty) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        searchUser(value, data);
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search User',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.blue))),
                    ),
                  ),
                  const NotFound(notFoundText: 'Contacts not found'),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Container(
                    child: widget.userType == 'Teacher'
                        ? const Text(
                            'Student '
                            'Chat'
                            ' List',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          )
                        : const Text(
                            'Teacher Chat '
                            'List',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2),
                          ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    onChanged: (value) {
                      searchUser(value, data);
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search User',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: userData.isEmpty
                          ? data.map(buildListTileForStudent).toList()
                          : userData.map(buildListTileForStudent).toList(),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SpinKitFadingCircle(
                  color: Colors.blue,
                  size: 50,
                )
              ],
            );
          } else {
            return const NoData(
              noDataText: 'No users yet...',
            );
          }
        });
  }

  Stream<List<UserInfo>> readUser() => FirebaseFirestore.instance
      .collection('Users')
      .where('userType',
          isEqualTo: widget.userType == 'Teacher' ? 'Student' : 'Teacher')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((e) => UserInfo.fromJson(e.data())).toList());

  Widget buildListTileForStudent(UserInfo e) => Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatMain(
                          badgeChange: () {
                            setState(() {
                              badgeCount++;
                            });
                          },
                          clickName: e.name,
                          userID: widget.uid,
                          clickID: e.userID,
                          clickUserType: e.userType,
                          userName: widget.userName,
                          userType: widget.userType)));
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blue[900],
              child: Center(
                child: Text(
                  e.name.substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            title: Text(e.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.school,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
                Text(
                  e.userType,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                )
              ],
            ),
            trailing: Badge(
                badgeContent: Text(badgeCount.toString()),
                child: const Icon(Icons.message_sharp)),
          ),
        ),
      );

  void searchUser(String query, List<UserInfo> data) {
    final suggestions = data.where(((value) {
      final name = value.name.toLowerCase();
      final input = query.toLowerCase();

      return name.contains(input);
    })).toList();
    if (query.isEmpty) {
      setState(() {
        userData = [];
      });
    } else {
      setState(() {
        userData = suggestions;
      });
    }
  }
}
