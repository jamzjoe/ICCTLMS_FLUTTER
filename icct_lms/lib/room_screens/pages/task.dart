import 'package:flutter/material.dart';
import 'package:icct_lms/models/quiz_list_model.dart';
import 'package:icct_lms/room_screens/pages/quiz_play.dart';
import 'package:icct_lms/services/quizzes.dart';

class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}
  final QuizServices _quizServices = QuizServices();
class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuizModel>>(
        stream: _quizServices.readQuiz(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final data = snapshot.data;
            return ListView(
              children: data!.map(quizTiles).toList(),
            );
          }else{
            return Text('Error');
          }
        });
  }

 

  Widget quizTiles(QuizModel e) {
  return ListTile(
    title: Text(e.quizTitle),
    subtitle: Text(e.quizDesc),
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          QuizPlay(e.quizID, e.quizTitle)));
    },
  );
  }
}
