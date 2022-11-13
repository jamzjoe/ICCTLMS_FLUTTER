class AnswerPreviewModel {
  String? answer;
  String? questionID;
  String? quizID;

  AnswerPreviewModel({this.answer, this.questionID, this.quizID});

  AnswerPreviewModel.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    questionID = json['questionID'];
    quizID = json['quizID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['questionID'] = this.questionID;
    data['quizID'] = this.quizID;
    return data;
  }
}
