import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ChatService{
  String chatID = const Uuid().v4().substring(0, 8);
  final chatReference = FirebaseFirestore.instance.collection('Chat');
  Future sendChat(String teacherUID, String studentID, String name, String
  userID, String userType, String date, String hour, String message, String
  sortKey)
  async{
    final task = chatReference.doc(teacherUID).collection(studentID).doc(chatID);
    await task.set({
      'name': name,
      'hour': hour,
      'sortKey': sortKey,
      'date': date,
      'chatID': chatID,
      'userID': userID,
      'message': message
    });
  }
}