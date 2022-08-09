import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icct_lms/models/class_model.dart';
import 'package:icct_lms/models/group_model.dart';

class ClassService {
  Future createClass(Class classInfo, String userID, String roomCode) async {
    final docUser = FirebaseFirestore.instance
        .collection('Rooms')
        .doc('Class')
        .collection(userID)
        .doc(roomCode);
    final json = classInfo.toJson();
    await docUser.set(json);
  }

  Future createGroup(Group groupInfo, String userID, String roomCode) async {
    final docUser = FirebaseFirestore.instance
        .collection('Rooms')
        .doc('Group')
        .collection(userID)
        .doc(roomCode);
    final json = groupInfo.toJson();
    await docUser.set(json);
  }

  Future deleteRoom(String roomType, String userID, String roomCode) async {
    final docUser = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(roomType)
        .collection(userID)
        .doc(roomCode);

    await docUser.delete();
    docUser.collection("Post").get().then((value) async {
      for (DocumentSnapshot snapshot in value.docs) {
        await snapshot.reference.delete();
      }
    });
    docUser.collection("Members").get().then((value) async {
      for (DocumentSnapshot snapshot in value.docs) {
        await snapshot.reference.delete();
      }
    });
  }

  Future switchRestriction(
      String roomType, String userID, String roomCode, String restrict) async {
    final docUser = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(roomType)
        .collection(userID)
        .doc(roomCode);
    await docUser.update({
      'restriction': restrict,
      'virtual': '',
      'attendance': ''
          ''
    });
  }

  Future updateLinks(String roomType, String userID, String roomCode,
      String virtual, String attendance) async {
    final docUser = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(roomType)
        .collection(userID)
        .doc(roomCode);
    await docUser.update({'virtual': virtual, 'attendance': attendance});
  }
}
