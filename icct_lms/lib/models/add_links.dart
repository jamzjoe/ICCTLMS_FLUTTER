import 'package:cloud_firestore/cloud_firestore.dart';

class AddLinks {
  final String roomType,
      userID,
      teacherUID,
      roomCode,
      subjectName,
      teacher,
      virtual,
      attendance;

  AddLinks(this.roomType, this.userID, this.teacherUID, this.roomCode,
      this.subjectName, this.teacher, this.virtual, this.attendance);

  Map<String, dynamic> toJson() => {
        'roomType': roomType,
        'code': roomCode,
        'teacher': teacher,
        'name': subjectName,
        'userID': userID,
        'teachersID': teacherUID,
        'virtual': virtual,
        'attendance': attendance
      };

  static AddLinks fromJson(Map<String, dynamic> json) => AddLinks(
      json['roomType'] ?? 'RoomType',
      json['userID'] ?? 'UserID',
      json['teacherUID'] ?? 'TeacherUID',
      json['code'] ?? 'Code',
      json['name'] ?? 'Name',
      json['teacher'] ?? 'Teacher',
      json['virtual'] ?? 'Virtual',
      json['attendance'] ?? 'Attendance');
}
