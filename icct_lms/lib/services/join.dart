import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Joined {
  final String uid;
  Joined({required this.uid});

  final CollectionReference joinReference =
      FirebaseFirestore.instance.collection('Joined');
  final CollectionReference roomReference =
      FirebaseFirestore.instance.collection('Rooms');
  late bool isError;
  late String error;
  Future joinedTo(String roomType, String roomCode, String teacherUID,
      String userID, BuildContext context) async {
    try {
      await roomReference
          .doc(roomType)
          .collection(teacherUID)
          .doc(roomCode)
          .get()
          .then((value) async {
        var roomName = value['name'];
        var teacher = value['teacher'];

        joinReference.doc(roomType).collection(userID).doc(roomCode).set({
          'userID': userID,
          'teacher': teacher,
          'roomName': roomName,
          'roomType': roomType,
          'roomCode': roomCode,
          'teacherUID': teacherUID
        });
      });
    } catch (e) {
      if(kDebugMode){
        print("Error boss");
      }
      isError = true;
    }
  }

  Future deleteJoin(String roomType, String roomCode, String userID) async {
    try {
      await joinReference.doc(roomType).collection(uid).doc(roomCode).delete();
    } catch (e) {
      error = e.toString();
    }
  }
}
