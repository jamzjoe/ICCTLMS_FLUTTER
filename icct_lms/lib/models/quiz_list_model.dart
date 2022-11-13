class QuizModel {
  final String roomID,
      quizDesc,
      quizTitle;
  final String quizID, time_duration, professor;

  QuizModel(this.roomID, this.quizDesc, this.quizTitle, this.quizID, this.time_duration, this.professor);

  Map<String, dynamic> toJson() => {
    "roomID": roomID,
    "quizDesc": quizDesc,
    "quizTitle": quizTitle,
    "quizID": quizID,
    "time_duration": time_duration,
    "professor": professor
  };

  static QuizModel fromJson(Map<String, dynamic> json) => QuizModel(
      json['roomID'] ?? 'roomID',
      json['quizDesc'] ?? 'quizDesc',
      json['quizTitle'] ?? 'quizTitle',
      json['quizID'] ?? 'quizID',
    json['time_duration'] ?? 'time_duration',
    json['professor'] ?? 'professor'
  );
}
