class JoinedModel {
  final String roomType, roomCode, teacherUID, roomName, userID, teacher;

  JoinedModel(
      {required this.roomType,
      required this.roomCode,
      required this.teacherUID,
      required this.userID,
      required this.roomName,
      required this.teacher});

  Map<String, dynamic> toJson() => {
        'teacher': teacher,
        'roomName': roomName,
        'roomCode': roomCode,
        'roomType': roomType,
        'teacherUID': teacherUID,
        'userID': userID
      };

  static JoinedModel fromJson(Map<String, dynamic> json) => JoinedModel(
      roomType: json['roomType'],
      roomCode: json['roomCode'],
      teacherUID: json['teacherUID'],
      roomName: json['roomName'],
      userID: json['userID'],
      teacher: json['teacher']);
}
