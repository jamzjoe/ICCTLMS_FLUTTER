import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Post{
  Future createPost(roomType, teacherUID, roomCode, String message, String
  name, String userID)
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
     'userID': userID
   });
  }
}