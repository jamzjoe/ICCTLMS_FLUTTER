import 'package:flutter/material.dart';
import 'package:icct_lms/components/loading.dart';
import 'package:icct_lms/components/nodata.dart';
import 'package:icct_lms/models/joined_model.dart';
import 'package:icct_lms/models/quiz_list_model.dart';
import 'package:icct_lms/models/quiz_status.dart';
import 'package:icct_lms/room_screens/pages/quiz_play.dart';
import 'package:icct_lms/room_screens/pages/task_screen/completed.dart';
import 'package:icct_lms/room_screens/pages/task_screen/out_of_date.dart';
import 'package:icct_lms/room_screens/pages/task_screen/grades.dart';
import 'package:icct_lms/services/quizzes.dart';
import 'package:intl/intl.dart';

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
          if (data.isEmpty) {
            return const NoData(noDataText: 'No quizzes yet');
          }
          final List<String> room = data.map((e) => e.roomCode).toList();
          return StreamBuilder<List<QuizModel>>(
              stream: _quizServices.readRoomsQuiz(room, widget.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  if (data!.isEmpty) {
                    return const NoData(noDataText: 'No quizzes yet');
                  }
                  return StreamBuilder<List<QuizStatus>>(
                      stream: _quizServices.readStatus(widget.uid),
                      builder: (context, status) {
                        if (status.hasData) {
                          final quiz_status = status.data;
                          if (quiz_status!.isEmpty) {
                            Column(
                              children: [
                                TaskHeader(),
                                Container(
                                    child: ListView(
                                        shrinkWrap: true,
                                        children: data
                                            .map((e) => createQuizTile(
                                                e, context, true, []))
                                            .toList()))
                              ],
                            );
                          }
                          final qStatus = _quizServices.readStatus(widget.uid);
                          qStatus.map((event) =>
                              event.map((e) => e.quizID.toString()).toList());

                          return Column(
                            children: [
                              TaskHeader(),
                              Container(
                                  child: ListView(
                                      shrinkWrap: true,
                                      children: data
                                          .map((e) => createQuizTile(
                                              e,
                                              context,
                                              true,
                                              quiz_status
                                                  .map((e) =>
                                                      e.quizID.toString())
                                                  .toList()))
                                          .toList()))
                            ],
                          );
                        }
                        return Column(
                          children: [
                            TaskHeader(),
                            Container(
                                child: ListView(
                                    shrinkWrap: true,
                                    children: data
                                        .map((e) => createQuizTile(
                                            e, context, true, []))
                                        .toList()))
                          ],
                        );
                      });
                }
                return const NoData(
                    noDataText: 'No quizzes yet or something '
                        'went '
                        'wrong!');
              });
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        return const NoData(
            noDataText: 'No quizzes yet or something went '
                'wrong!');
      }),
    );
  }

  Widget createQuizTile(
      QuizModel e, BuildContext context, bool status, List<String>? list) {
    var isDue = e.due_date.toDate().difference(DateTime.now()).inDays == 0;
    bool isLate = e.due_date.toDate().difference(DateTime.now()).isNegative;
    bool isCompleted = list!.any((element) => element.contains(e.quizID));
    return Visibility(
      visible: !isCompleted,
      child: Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            border: Border.all(
                color: isDue
                    ? Colors.red
                    : isLate
                        ? Colors.black45
                        : Colors.blue),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          onTap: () {
            if (!isLate) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizPlay(
                            e.quizID,
                            e.quizTitle,
                            quizDescription: e.quizDesc,
                            duration: e.time_duration.split(':'),
                            professor: e.professor,
                            e: e,
                          )));
            } else if (isDue) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizPlay(
                            e.quizID,
                            e.quizTitle,
                            quizDescription: e.quizDesc,
                            duration: e.time_duration.split(':'),
                            professor: e.professor,
                            e: e,
                          )));
            } else {
              return null;
            }
          },
          trailing: isDue
              ? Text(
                  'Due',
                  style: TextStyle(
                      color: Colors.red.shade600, fontWeight: FontWeight.bold),
                )
              : isLate
                  ? Text('Late')
                  : Text(''),
          title: Text(
            '${e.quizTitle}',
            style: TextStyle(color: Colors.black87),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.quizDesc,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w300,
                    fontSize: 12),
              ),
              Text(DateFormat.yMMMEd().format(e.due_date.toDate()))
            ],
          ),
        ),
      ),
    );
  }
}

class TaskHeader extends StatelessWidget {
  const TaskHeader({
    Key? key,
  }) : super(key: key);

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
                  avatar: CircleAvatar(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green,
                  ),
                  label: Text('Completed')),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TaskCompleted()));
              },
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              child: Chip(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  avatar: CircleAvatar(
                    child: Icon(
                      Icons.schedule,
                      color: Colors.red,
                    ),
                    backgroundColor: Colors.white,
                  ),
                  label: Text('Out of Date')),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OutOfDateTask()));
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Grades(
                              roomID: '',
                            )));
              },
            )
          ],
        )
      ],
    );
  }
}
