import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icct_lms/models/quiz_list_model.dart';

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


  Stream<List<QuizModel>> readQuiz() {
    return FirebaseFirestore.instance
        .collection('Quiz')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => QuizModel.fromJson(doc.data()))
        .toList());
  }

  getQuestionData(String quizId) async{
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }
}