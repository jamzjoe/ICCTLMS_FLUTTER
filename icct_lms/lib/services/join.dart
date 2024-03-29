import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:icct_lms/models/joined_model.dart';

class Joined {
  final String uid;
  Joined({required this.uid});

  final CollectionReference joinReference =
      FirebaseFirestore.instance.collection('Joined');
  final CollectionReference roomReference =
      FirebaseFirestore.instance.collection('Rooms');
  Future joinedTo(String roomType, String roomCode, String teacherUID,
      String userID) async {
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
      return;
    }
  }

  Future getTeacher(String roomType, String roomCode, String teacherUID,
      String userID) async {
    try {
      await roomReference
          .doc(roomType)
          .collection(teacherUID)
          .doc(roomCode)
          .get()
          .then((value) async {
        var roomName = value['name'];
        var teacher = value['teacher'];
        joinRoomTo(roomName, teacher, roomType, roomCode, teacherUID, userID);
      });
    } catch (e) {
      return null;
    }
  }

  Future deleteJoin(String roomType, String roomCode, String userID, String
  teacherUID) async {
    DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection
      ('Rooms').doc(roomType).collection(teacherUID).doc(roomCode).collection
      ('Members').doc(userID);
    final deleteJoin = joinReference.doc(roomType).collection(userID).doc
    (roomCode);
    try {
      await joinReference.doc(roomType).collection(uid).doc(roomCode).delete();
      await reference.delete();
      await deleteJoin.delete();
    } catch (e) {
      return null;
    }
  }



  Future joinRoomTo(
      roomName, teacher, roomType, roomCode, teacherUID, userID) async {
    try {
      await joinReference.doc(roomType).collection(userID).doc(roomCode).set({
        'userID': userID,
        'teacher': teacher,
        'roomName': roomName,
        'roomType': roomType,
        'roomCode': roomCode,
        'teacherUID': teacherUID
      });
    } catch (e) {
      return null;
    }
  }
}
