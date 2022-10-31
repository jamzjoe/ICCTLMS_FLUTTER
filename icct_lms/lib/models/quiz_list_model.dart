class QuizModel {
  final String roomID,
      quizDesc,
      quizTitle;
  final String quizID;

  QuizModel(this.roomID, this.quizDesc, this.quizTitle, this.quizID);

  Map<String, dynamic> toJson() => {
    "roomID": roomID,
    "quizDesc": quizDesc,
    "quizTitle": quizTitle,
    "quizID": quizID
  };

  static QuizModel fromJson(Map<String, dynamic> json) => QuizModel(
      json['roomID'] ?? 'roomID',
      json['quizDesc'] ?? 'quizDesc',
      json['quizTitle'] ?? 'quizTitle',
      json['quizID'] ?? 'quizID'
  );
}
