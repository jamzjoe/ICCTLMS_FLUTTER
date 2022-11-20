import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String roomID,
      quizDesc,
      quizTitle;
  final String quizID, time_duration, professor;
  final Timestamp created, due_date;

  QuizModel(this.roomID, this.quizDesc, this.quizTitle, this.quizID, this.time_duration, this.professor, this.created, this.due_date);

  Map<String, dynamic> toJson() => {
    "roomID": roomID,
    "quizDesc": quizDesc,
    "quizTitle": quizTitle,
    "quizID": quizID,
    "time_duration": time_duration,
    "professor": professor,
    'due_date': due_date,
    'created': created
  };

  static QuizModel fromJson(Map<String, dynamic> json) => QuizModel(
      json['roomID'] ?? 'roomID',
      json['quizDesc'] ?? 'quizDesc',
      json['quizTitle'] ?? 'quizTitle',
      json['quizID'] ?? 'quizID',
    json['time_duration'] ?? 'time_duration',
    json['professor'] ?? 'professor',
    json['created'] ?? 'created',
    json['due_date'] ?? 'due date'
  );
}
