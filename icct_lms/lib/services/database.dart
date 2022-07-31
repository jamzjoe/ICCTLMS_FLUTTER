import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icct_lms/models/user_info.dart';

class DatabaseService {
  //collection reference
  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference userInformation =
      FirebaseFirestore.instance.collection('Users');

  Future updateUserDetails(String username, String emailAddress, String campus,
      String userType) async {
    return await userInformation.doc(uid).set({
      'username': username,
      'emailAddress': emailAddress,
      'campus': campus,
      'userType': userType
    });
  }

  List<UserInfo> userList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map value = doc.data() as Map;
      //print(doc.data);
      return UserInfo(
          name: value['username'] ?? '',
          school: value['campus'] ?? '',
          email: value['emailAddress'] ?? '',
          userType: value['userType'] ?? '');
    }).toList();
  }

  // query stream
  Stream<List<UserInfo>> get user {
    return userInformation.snapshots().map(userList);
  }
}
