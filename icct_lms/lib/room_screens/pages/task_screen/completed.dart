import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/models/quiz_status.dart';
import 'package:icct_lms/services/quizzes.dart';
import 'package:intl/intl.dart';

class TaskCompleted extends StatefulWidget {
  const TaskCompleted({Key? key}) : super(key: key);

  @override
  State<TaskCompleted> createState() => _TaskCompletedState();
}

final QuizServices _quizServices = QuizServices();
final userID = FirebaseAuth.instance.currentUser!.uid;

class _TaskCompletedState extends State<TaskCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Task'),
      ),
      body: StreamBuilder<List<QuizStatus>>(
        stream: _quizServices.readStatus(userID),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            final data = snapshot.data;
            if(data!.isEmpty){
              return NoData(noDataText: 'No Completed Task Yet');
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: data.map(createTile).toList(),
                  )
                )
              ],
            );
          }else if(snapshot.hasError){
            print(snapshot.error);
            return Text(snapshot.error.toString());
          }
          return Center(
            child: Text('Completed Task'),
          );
        }
      ),
    );
  }

  Widget createTile(QuizStatus e) => Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              Colors.blue.shade50
            ],
          ),
          border: Border.all(color: Colors
              .black54),
          borderRadius: BorderRadius.circular(10)
      ),
      child: ListTile(
        title: Text(e.quizTitle.toString()),
        subtitle: Text(e.quizDesc.toString(),overflow: TextOverflow.ellipsis,),
        trailing: Chip(
          backgroundColor: Colors.white,
          elevation: .3,
          label: Text('Score: ${e.score} '
              'out of ${e
              .total}'),
        ),
      ),
    ),
  );
}
