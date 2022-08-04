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

  Future createPublicPost(String roomType, String roomCode,
      String message,
      String
  name, String userID, String userType, String roomName)
  async {
    String postID = const Uuid().v4().substring(0, 8);
    DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection
      ('Post').doc(postID);
    final now = DateTime.now();
    String hour = DateFormat.jm().format(now);
    String date = DateFormat.yMMMMd('en_US').format(now);
    String sortKey = DateTime.now().millisecondsSinceEpoch.toString();
    reference.set({
      'roomName': roomName,
      'roomCode': roomCode,
      'message': message,
      'date': date,
      'hour': hour,
      'sortKey': sortKey,
      'postName': name,
      'postID': postID,
      'userID': userID,
      'userType': userType
    });
  }

  Future deletePublicPost(String postID)async{
    DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection
      ('Post').doc(postID);

    await reference.delete();
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
  name, String userID, String postID,String userType, String roomName)
  async {
    DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection
      ('Rooms').doc(roomType).collection(teacherUID).doc(roomCode).collection
      ('Post').doc(postID);
    final now = DateTime.now();
    String date = DateFormat.yMMMMd('en_US').format(now);
    String sortKey = DateTime.now().millisecondsSinceEpoch.toString();
    reference.set({
      'roomName': roomName,
      'message': message,
      'date': date,
      'sortKey': sortKey,
      'postName': name,
      'postID': postID,
      'userID': userID,
      'userType': userType
    });
  }

  Future updatePublicPost(String roomType, String roomCode,
      String message,
      String
      name, String userID, String userType, String postID, String roomName)
  async {
    DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore.instance.collection
      ('Post').doc(postID);
    final now = DateTime.now();
    String hour = DateFormat.jm().format(now);
    String date = DateFormat.yMMMMd('en_US').format(now);
    String sortKey = DateTime.now().millisecondsSinceEpoch.toString();
    reference.set({
      'roomName': roomName,
      'roomCode': roomCode,
      'message': message,
      'date': date,
      'hour': hour,
      'sortKey': sortKey,
      'postName': name,
      'postID': postID,
      'userID': userID,
      'userType': userType
    });
  }

  Future deleteEachRoomPost(String roomCode)async{
    final reference = FirebaseFirestore.instance.collection
      ('Post');
     await reference.where('roomCode', isEqualTo: roomCode).get().then((value){
       for(DocumentSnapshot snapshot in value.docs){
         snapshot.reference.delete();
       }
     });

  }
}