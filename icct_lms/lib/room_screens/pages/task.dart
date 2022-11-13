import 'package:flutter/material.dart';
import 'package:icct_lms/components/loading.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/models/quiz_list_model.dart';
import 'package:icct_lms/room_screens/pages/quiz_play.dart';
import 'package:icct_lms/services/quizzes.dart';

class Task extends StatefulWidget {
  const Task({Key? key, required this.roomID}) : super(key: key);
  final String roomID;
  @override
  State<Task> createState() => _TaskState();
}

final QuizServices _quizServices = QuizServices();

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuizModel>>(
        stream: _quizServices.readRoomsQuiz([widget.roomID]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data!.isEmpty) {
              return const NoData(noDataText: 'No quizzes yet');
            }
            return ListView(
              children: data.map(quizTiles).toList(),
            );
          } else if(snapshot.hasError) {
            return const Text('Error');
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return const Loading();
          }
          return const NoData(noDataText: 'No quizzes yet or something went '
              'wrong!');
        });
  }

  Widget quizTiles(QuizModel e) {
    return InkWell(
      splashColor: Colors.blue,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: ListTile(
          title: Text(e.quizTitle),
          subtitle: Text(e.quizDesc),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>

                        // QuizRoom(title: e.quizTitle,  quizID: e.quizID)
                        QuizPlay(e.quizID, e.quizTitle,
                            quizDescription: e.quizDesc,
                            duration: e.time_duration.split(':'),
                            professor: e.professor)));
          },
        ),
      ),
    );
  }
}
