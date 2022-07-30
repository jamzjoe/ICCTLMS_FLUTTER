import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class PostService{
  Future createPost(roomType, teacherUID, roomCode, String message, String
  name, String userID, String userType)
  async {
    String postID = const Uuid().v4().substring(0, 8);
   DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection
      ('Rooms').doc(roomType).collection(teacherUID).doc(roomCode).collection
     ('Post').doc(postID);
   final now = DateTime.now();
   String date = DateFormat.yMMMMd('en_US').format(now);
   String sortKey = DateTime.now().millisecondsSinceEpoch.toString();
   reference.set({
     'message': message,
     'date': date,
     'sortKey': sortKey,
     'postName': name,
     'postID': postID,
     'userID': userID,
     'userType': userType
   });
  }
  Future addToMember(roomType, teacherUID, roomCode, String
  name, String userID, String userType)async{
    DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection
      ('Rooms').doc(roomType).collection(teacherUID).doc(roomCode).collection
      ('Members').doc(userID);
    String sortKey = DateTime.now().millisecondsSinceEpoch.toString();
    await reference.set({
      'userID': userID,
      'userType': userType,
      'name': name,
      'sortKey': sortKey
    });
  }
  Future deletePost(roomType, teacherUID, roomCode, String message, String
  name, String userID, postID)async{
    DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection
      ('Rooms').doc(roomType).collection(teacherUID).doc(roomCode).collection
      ('Post').doc(postID);

        await reference.delete();
  }
  Future updatePost(roomType, teacherUID, roomCode, String message, String
  name, String userID, String postID,String userType)
  async {
    DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection
      ('Rooms').doc(roomType).collection(teacherUID).doc(roomCode).collection
      ('Post').doc(postID);
    final now = DateTime.now();
    String date = DateFormat.yMMMMd('en_US').format(now);
    String sortKey = DateTime.now().millisecondsSinceEpoch.toString();
    reference.set({
      'message': message,
      'date': date,
      'sortKey': sortKey,
      'postName': name,
      'postID': postID,
      'userID': userID,
      'userType': userType
    });
  }

}