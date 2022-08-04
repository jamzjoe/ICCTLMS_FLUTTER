import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CommentService{

  Future createComment(String postID, String message, String name, String
  userID, String userType) async{

    String commentID = const Uuid().v4().substring(0, 8);
    DocumentReference<Map<String, dynamic>> reference = FirebaseFirestore
        .instance.collection
      ('Post').doc(postID).collection('Comment').doc(commentID);

    final now = DateTime.now();
    String hour = DateFormat.jm().format(now);
    String date = DateFormat.yMMMMd('en_US').format(now);
    String sortKey = DateTime.now().millisecondsSinceEpoch.toString();
    await reference.set(
      {
        'message': message,
        'date': date,
        'hour': hour,
        'sortKey': sortKey,
        'name': name,
        'commentID': commentID,
        'userID': userID,
        'userType': userType
      }
    );
  }
}