import 'package:flutter/material.dart';
import 'package:icct_lms/components/loading.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/models/joined_model.dart';
import 'package:icct_lms/models/quiz_list_model.dart';
import 'package:icct_lms/quiz/quiz_room.dart';
import 'package:icct_lms/quiz/timer.dart';
import 'package:icct_lms/room_screens/pages/quiz_play.dart';
import 'package:icct_lms/services/quizzes.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

final QuizServices _quizServices = QuizServices();

class _PlannerScreenState extends State<PlannerScreen> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<JoinedModel>>(
      stream: _quizServices.readJoinedGroup(widget.uid),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          if(data.isEmpty){
            return const NoData(noDataText: 'No quizzes yet');
          }
          final List<String> room = data.map((e) => e.roomCode).toList();
          return StreamBuilder<List<QuizModel>>(
              stream: _quizServices.readRoomsQuiz(room),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  if(data!.isEmpty){
                    return const NoData(noDataText: 'No quizzes yet');
                  }
                  return ListView(
                    children: data.map(quizTiles).toList(),
                  );
                } else if(snapshot.connectionState == ConnectionState.waiting){
                  return const Loading();
                }
                return const NoData(noDataText: 'No quizzes yet or something '
                    'went '
                    'wrong!');
              });
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return const Loading();
        }
        return const NoData(noDataText: 'No quizzes yet or something went '
            'wrong!');
      }),
    );
  }

  Widget quizTiles(QuizModel e) {
    return ListTile(
      title: Text(e.quizTitle),
      subtitle: Text(e.quizDesc),
      onTap: () {
       
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuizPlay(e.quizID, e.quizTitle, quizDescription:
                e.quizDesc, duration: e.time_duration.split(':'), professor: e
                    .professor)));
      },
    );
  }
}
