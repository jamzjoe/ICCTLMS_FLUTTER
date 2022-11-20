import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:icct_lms/bloc/quiz/quiz_bloc.dart';
import 'package:icct_lms/components/loading.dart';
import 'package:icct_lms/models/question_models.dart';
import 'package:icct_lms/models/quiz_list_model.dart';
import 'package:icct_lms/room_screens/pages/score_display.dart';
import 'package:icct_lms/services/notification_service.dart';
import 'package:icct_lms/services/push_notification.dart';
import 'package:icct_lms/services/quizzes.dart';
import '../../quiz/quiz_play_widgets.dart';

class QuizPlay extends StatefulWidget {
  final String quizId;
  final String quizTitle;
  final List<String> duration;
  final String quizDescription;
  final String professor;
  final QuizModel e;
  const QuizPlay(this.quizId, this.quizTitle,
      {super.key,
      required this.quizDescription,
      required this.duration,
      required this.professor, required this.e});

  @override
  _QuizPlayState createState() => _QuizPlayState();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
FlutterLocalNotificationsPlugin();
int total = 0;
DateTime? due;

/// Stream
Stream? infoStream;

class _QuizPlayState extends State<QuizPlay> {
  QuerySnapshot? questionSnaphot;
  QuizServices? databaseService = QuizServices();

  bool isLoading = true;

  PushNotification _pushNotification = PushNotification();
  String counText = '';

  @override
  void initState() {
    due = widget.e.due_date.toDate();
    Timer.run(() async {
      BlocProvider.of<QuizBloc>(context).add(LoadQuiz());
      showDialog(
          barrierDismissible: false,
          context: (context),
          builder: (context) => CupertinoAlertDialog(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title: ${widget.quizTitle}'),
                    const SizedBox(
                      height: 3,
                    ),
                    Text('Description: ${widget.quizDescription}'),
                    Text(
                        'Duration: ${widget.duration[0]}:${widget
                            .duration[1]}'),
                    Text('Due date: ${due!.month}/${due!.day}/${due!.year}')
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        BlocProvider.of<QuizBloc>(context)
                            .add(const StartQuiz(0));
                      },
                      child: const Text('Start')),
                ],
              ));
    });

    databaseService!.getQuestionData(widget.quizId).then((value) {
      questionSnaphot = value;
      _notAttempted = questionSnaphot!.docs.length;
      _correct = 0;
      _incorrect = 0;
      isLoading = false;
      total = questionSnaphot!.docs.length;
      setState(() {});
      print("init don $total ${widget.quizId} ");
    });
    final secHour = int.parse(widget.duration[0]) * 3600;
    final minHour = int.parse(widget.duration[1]) * 60;
    final seconds = secHour + minHour;
    print(seconds);
    infoStream ??= Stream<List<int>>.periodic(const Duration(seconds: 1), (x) {
      print("this is x $x");
      counText = x.toString();
      if (x == seconds) {
        infoStream!.timeout(Duration(seconds: seconds));
        showDialog(
            barrierDismissible: false,
            context: (context),
            builder: (context) => CupertinoAlertDialog(
                  content: const Text(
                    'Time is end! I hope you answer it all'
                    '.',
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Exit'))
                  ],
                )).then((value) => Navigator.pop(context));
      }
      return [_correct, _incorrect];
    });

    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = QuestionModel();

    questionModel.question = questionSnapshot.get("question");

    /// shuffling the options
    List<String> options = [
      questionSnapshot.get("option1"),
      questionSnapshot.get("option2"),
      questionSnapshot.get("option3"),
      questionSnapshot.get("option4"),
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.get("option1");
    questionModel.answered = false;

    print(questionModel.correctOption.toLowerCase());

    return questionModel;
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final result = await showCupertinoDialog(
            context: (context),
            builder: (context) => CupertinoAlertDialog(
                  content:
                      const Text('This will exit the quiz, please make sure you'
                          ' have already answered the quiz.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          BlocProvider.of<QuizBloc>(context)
                              .add(EndQuiz('0', total.toString()));
                          Navigator.pop(context);
                        },
                        child: const Text('Understood')),
                  ],
                ));
        if (result == null) {
          return false;
        }
        return true;
      },
      child: BlocBuilder<QuizBloc, QuizState>(builder: (context, state) {
        print(state);
        if (state is QuizStartState) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                    onPressed: () {
                      showCupertinoDialog(
                          context: (context),
                          builder: (context) => CupertinoAlertDialog(
                                content: const Text(
                                    'This will exit the quiz, please make sure you'
                                    ' have already answered the quiz.'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () async{
                                        NotificationService.showNotification
                                          (title: '${widget.quizTitle}',
                                            body: 'Score: ${_correct}/${total}',
                                            flutterLocalNotificationsPlugin:
                                            _localNotificationsPlugin);
                                            BlocProvider.of<QuizBloc>(context).add(
                                                EndQuiz('0', total.toString()));
                                            Navigator.pop(context);
                                      },
                                      child: const Text('Understood')),
                                ],
                              ));
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
              title: Text(widget.quizTitle),
              centerTitle: true,
              backgroundColor: Colors.blue,
              elevation: 0.0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: isLoading
                ? Container(
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          InfoHeader(
                            length: questionSnaphot!.docs.length,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          questionSnaphot!.docs == null
                              ? Container(
                                  child: const Center(
                                    child: Text("No Data"),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: questionSnaphot!.docs.length,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return QuizPlayTile(
                                      questionModel:
                                          getQuestionModelFromDatasnapshot(
                                              questionSnaphot!.docs[index]),
                                      index: index,
                                    );
                                  })
                        ],
                      ),
                    ),
                  ),
          );
        } else if (state is QuizLoading) {
          return const Loading();
        } else if (state is QuizEndState) {
          return ScoreDisplay(
            score: _correct.toString(),
            total: total.toString(),
            title: widget.quizTitle,
            description: widget.quizDescription,
            professor: widget.professor,
            duration: widget.duration,
          );
        }
        return const Loading();
      }),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  const InfoHeader({required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 14),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      NoOfQuestionTile(
                        text: "Total",
                        number: widget.length,
                      ),
                      NoOfQuestionTile(
                        text: "Correct",
                        number: _correct,
                      ),
                      NoOfQuestionTile(
                        text: "Incorrect",
                        number: _incorrect,
                      ),
                      NoOfQuestionTile(
                        text: "NotAttempted",
                        number: _notAttempted,
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  const QuizPlayTile({required this.questionModel, required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Q${widget.index + 1} ${widget.questionModel.question}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "A",
              description: widget.questionModel.option1,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "B",
              description: widget.questionModel.option2,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "C",
              description: widget.questionModel.option3,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "D",
              description: widget.questionModel.option4,
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
