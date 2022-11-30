import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icct_lms/models/answer_preview.dart';
import 'package:icct_lms/models/joined_model.dart';
import 'package:icct_lms/models/quiz_list_model.dart';
import 'package:icct_lms/models/quiz_model.dart';
import 'package:icct_lms/models/quiz_status.dart';

class QuizServices{
  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId)
  async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuizPreview(Map<String, dynamic> quizData,
  String quizID, String userID, String questionID)
  async{
    await FirebaseFirestore.instance
        .collection('Quiz Preview')
        .doc(userID)
        .collection(quizID)
        .doc(questionID)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Stream<List<AnswerPreviewModel>> readAnswerPreview(String userID, String
  quizID, String questionID){
    return FirebaseFirestore.instance
        .collection('Quiz Preview')
        .doc(userID)
        .collection(quizID)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => AnswerPreviewModel.fromJson(doc.data()))
        .toList());
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

Future<void> addGradesStatus(String quizID, gradesData, String userID)async{
  await FirebaseFirestore.instance
      .collection("Quiz")
      .doc(userID)
      .collection('Status')
      .doc(quizID)
      .set(gradesData).catchError((e){});
}

Stream<List<QuizStatus>> readStatus(String userID){
    return FirebaseFirestore.instance
        .collection("Quiz")
        .doc(userID)
        .collection('Status')
        .orderBy('submitted', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((e) => QuizStatus.fromJson(e.data()))
        .toList()
    );
}




  Stream<List<QuizModel>> readQuiz() {
    return FirebaseFirestore.instance
        .collection('Quiz')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => QuizModel.fromJson(doc.data()))
        .toList());
  }

  Stream<List<QuizModel>> readRoomsQuiz(List<String> room, String userID) {
    final status = readStatus(userID);
    final data = FirebaseFirestore.instance
        .collection('Quiz')
        .where('roomID', whereIn: room)
        .orderBy('due_date', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => QuizModel.fromJson(doc.data()))
        .toList().toList());

    return data;
  }

  Stream<List<JoinedModel>> readJoinedGroup(String userID) {
    return FirebaseFirestore.instance
        .collection('Joined')
        .doc('Group')
        .collection(userID)
        .snapshots()
        .map((event) =>
        event.docs.map((e) => JoinedModel.fromJson(e.data())).toList());
  }

  getQuestionData(String quizId) async{
    return FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }

  Stream<List<Quiz>> getQuizzes(String quizID){
    return FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizID)
        .collection("QNA")
        .snapshots()
        .map((event) => event.docs.map((e) => Quiz.fromJson(e.data()))
        .toList());
  }

  // Stream<List<QandAModel>> streamQuestions(String quizID){
  //   return FirebaseFirestore.instance
  //       .collection("Quiz")
  //       .doc(quizID)
  //       .collection("QNA")
  //       .snapshots()
  //       .map((event) => event.docs.map((e) => QandAModel.fromJson(e.data()))
  //       .toList());
  // }
  // Stream<List<QandAModel>> streamAnswers(String quizID){
  //   return FirebaseFirestore.instance
  //       .collection("Quiz")
  //       .doc(quizID)
  //       .collection("QNA")
  //       .snapshots()
  //       .map((event) => event.docs.map((e) => QandAModel.fromJson(e.data()))
  //       .toList());
  // }
  


}