import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:icct_lms/components/loading.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/home_pages/profile.dart';
import 'package:icct_lms/models/quiz_list_model.dart';
import 'package:icct_lms/room_screens/pages/quiz_play.dart';
import 'package:icct_lms/room_screens/pages/task_screen/completed.dart';
import 'package:icct_lms/room_screens/pages/task_screen/grades.dart';
import 'package:icct_lms/room_screens/pages/task_screen/out_of_date.dart';
import 'package:icct_lms/services/quizzes.dart';
import 'package:intl/intl.dart';

class Task extends StatefulWidget {
  const Task({Key? key, required this.roomID}) : super(key: key);
  final String roomID;
  @override
  State<Task> createState() => _TaskState();
}

final QuizServices _quizServices = QuizServices();
String userID = FirebaseAuth.instance.currentUser.toString();

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuizModel>>(
        stream: _quizServices.readRoomsQuiz([widget.roomID], userID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            // print(DateTime.now().difference(DateTime(2022, 11, 20)).inDays);
            if (data!.isEmpty) {
              return const NoData(noDataText: 'No quizzes yet');
            }
            return  Column(
              children: [
            TaskHeader(roomID: widget.roomID,),
                QuizList(data: data),
              ],
            );
          } else if(snapshot.hasError) {
            return Text('${snapshot.error}');
          }else if(snapshot.connectionState == ConnectionState.waiting){
            return const Loading();
          }
          return const NoData(noDataText: 'No quizzes yet or something went '
              'wrong!');
        });
  }
  
}

class QuizList extends StatelessWidget {
  const QuizList({
    Key? key,
    required this.data,
  }) : super(key: key);

  final List<QuizModel> data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GroupedListView<QuizModel, Timestamp>(elements: data, groupBy:
      ((element) => element.due_date),
          groupSeparatorBuilder: (value) => Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              child: Text(DateFormat.yMMMEd().format(value.toDate())),
            ),
          ),
          itemBuilder:
              (context, element) {
          var isDue = element.due_date.toDate().difference(DateTime
              .now())
              .inDays <= 1;
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white,
                        isDue ? Colors.red.shade50 : Colors.blue.shade50,
                      ],
                    ),
                  border: Border.all(color: isDue ? Colors.red : Colors
                      .black54),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: ListTile(
                  onTap: () => Navigator.push(context, MaterialPageRoute
                    (builder: (context) => QuizPlay(element.quizID, element
                      .quizTitle,
                      quizDescription: element.quizDesc, duration: element
                          .time_duration.split(':'),
                      professor:
                      element.professor, e: element))),
                  trailing: isDue? Text('Due', style: TextStyle(
                    color: Colors.red.shade600, fontWeight: FontWeight.bold
                  ),) : Text(''),
                  title: Text('${element.quizTitle}', style: TextStyle(
                    color: Colors.black87
                  ),),
                  subtitle: Text(element.quizDesc, overflow: TextOverflow
                      .ellipsis, style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w300,
                    fontSize: 12
                  ),),
                ),
              ),
            );
          }),
    );
  }
}

class TaskHeader extends StatelessWidget {
  const TaskHeader({
    Key? key, required this.roomID,
  }) : super(key: key);
  final String roomID;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                        child: Chip(
                            elevation: 1,
                            backgroundColor: Colors.white,
                            avatar:  CircleAvatar(
                              child: Icon(Icons.check_circle, color: Colors.white,),
                              backgroundColor: Colors.green,
                            ),
                            label: Text('Completed')),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TaskCompleted()));
                        },
                      ),
            SizedBox(width: 5,),
            GestureDetector(
              child: Chip(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  avatar: CircleAvatar(
                    child: Icon(Icons.schedule, color: Colors.red,),
                    backgroundColor: Colors.white,
                  ),
                  label: Text('Out of Date')),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) => OutOfDateTask()));
              },
            ),
          ],
        ),
        Spacer(),
        Row(
          children: [
            GestureDetector(
              child: Chip(
                avatar: CircleAvatar(
                  child: Icon(Icons.grade),
                ),
                elevation: 1,
                  backgroundColor: Colors.white,
                  label: Text('Grades')),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) => Grades(roomID: roomID,)));
              },
            )
          ],
        )
      ],
    );
  }
}
