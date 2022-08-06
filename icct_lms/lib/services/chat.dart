import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final chatReference = FirebaseFirestore.instance.collection('Chat');
  // Future startConversation(String clickUserID, String userID, String
  // userType, String userName)
  // async{
  //
  //   String chatID = const Uuid().v4().substring(0, 8);
  //   final data = {
  //     'userType': userType,
  //     'name':  userName,
  //     'chatID': chatID,
  //   };
  //   await chatReference.doc('Users').collection(clickUserID).doc(chatID).set(data);
  //   await chatReference.doc('Users').collection(userID).doc(chatID).set(data);
  // }

  Future sendChat(String teacherUID, String studentID, String name,
      String userID, String userType, String message) async {
    String chatID = const Uuid().v4().substring(0, 8);
    final now = DateTime.now();
    String date = DateFormat.yMMMMd('en_US').format(now);
    String hour = DateFormat.jm().format(now);
    String sortKey = DateTime.now().millisecondsSinceEpoch.toString();
    final task =
        chatReference.doc(teacherUID).collection(studentID).doc(chatID);
    await task.set({
      'name': name,
      'hour': hour,
      'sortKey': sortKey,
      'date': date,
      'chatID': chatID,
      'userID': userID,
      'message': message,
      'userType': userType
    });
  }

  Future deleteMessage(
      String teacherUID, String studentID, String chatID) async {
    final doc = chatReference.doc(teacherUID).collection(studentID).doc(chatID);
    await doc.delete();
  }
}
