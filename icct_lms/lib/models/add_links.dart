import 'package:cloud_firestore/cloud_firestore.dart';

class AddLinks {
  final String roomType, userID, teacherUID, roomCode, subjectName, teacher;

  AddLinks(this.roomType, this.userID, this.teacherUID, this.roomCode,
      this.subjectName, this.teacher);


  Map<String, dynamic> toJson() => {
        'roomType': roomType,
        'code': roomCode,
        'teacher': teacher,
        'name': subjectName,
        'userID': userID,
        'teachersID': teacherUID
      };

  static AddLinks fromJson(Map<String, dynamic> json) => AddLinks(
      json['roomType'],
      json['userID'],
      json['teacherUID'],
      json['roomCode'],
      json['subjectName'],
      json['teacher']);
}
