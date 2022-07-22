import 'package:cloud_firestore/cloud_firestore.dart';

class Joined{
  final String uid;
  late String error;
  Joined({required this.uid});

  final CollectionReference joinReference = FirebaseFirestore.instance
      .collection('Joined');
  final CollectionReference roomReference = FirebaseFirestore.instance
      .collection('Rooms');

  Future joinedTo(String roomType, String roomCode,String teacherUID, String
  userID)
  async{
    try{
       await roomReference.doc(roomType).collection(teacherUID)
        .doc(roomCode)
          .get().then((value)async{
        var roomName = value['name'];
        var teacher = value['teacher'];
        try{
          await joinReference.doc(roomType).collection(userID)
              .doc(roomCode).set({
            'userID': userID,
            'teacher': teacher,
            'roomName': roomName,
            'roomType': roomType,
            'roomCode': roomCode,
            'teacherUID': teacherUID
          });
        }on FirebaseException catch(e){
                error = e.message.toString();
        }
      }
      );
    }on FirebaseException catch(e){
      error = e.message.toString();
    }


  }
}