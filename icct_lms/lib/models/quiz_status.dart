import 'package:cloud_firestore/cloud_firestore.dart';

class QuizStatus {
  bool? answered;
  String? roomID;
  String? quizID;
  String? quizTitle;
  String? quizDesc;
  String? score;
  String? total;
  Timestamp? submitted;

  QuizStatus(
      {this.answered,
        this.roomID,
        this.quizID,
        this.quizTitle,
        this.quizDesc,
        this.score,
        this.total, this.submitted});

  QuizStatus.fromJson(Map<String, dynamic> json) {
    answered = json['answered'];
    roomID = json['roomID'];
    quizID = json['quizID'];
    quizTitle = json['quizTitle'];
    quizDesc = json['quizDesc'];
    score = json['score'];
    total = json['total'];
    submitted = json['submitted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answered'] = this.answered;
    data['roomID'] = this.roomID;
    data['quizID'] = this.quizID;
    data['quizTitle'] = this.quizTitle;
    data['quizDesc'] = this.quizDesc;
    data['score'] = this.score;
    data['total'] = this.total;
    data['submitted'] = this.submitted;
    return data;
  }
}
