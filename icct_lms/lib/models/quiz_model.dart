class Quiz {
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? questionID;
  Quiz({this.question, this.option1, this.option2, this.option3, this
      .option4, this.questionID});

  Quiz.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    option4 = json['option4'];
    questionID = json['questionID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = question;
    data['option1'] = option1;
    data['option2'] = option2;
    data['option3'] = option3;
    data['option4'] = option4;
    data['questionID'] = questionID;
    return data;
  }
}
