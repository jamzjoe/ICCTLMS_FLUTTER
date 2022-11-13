import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icct_lms/components/done.dart';
import 'package:icct_lms/components/something_wrong.dart';
import 'package:icct_lms/models/answer_preview.dart';
import 'package:icct_lms/models/quiz_model.dart';
import 'package:icct_lms/quiz/questions.dart';
import 'package:icct_lms/services/quizzes.dart';

class QuizRoom extends StatefulWidget {
  const QuizRoom({Key? key, required this.title, required this.quizID})
      : super(key: key);
  final String title;
  final String quizID;
  @override
  State<QuizRoom> createState() => _QuizRoomState();
}

var quizIndex = 0;
final QuizServices _quizServices = QuizServices();

class _QuizRoomState extends State<QuizRoom> {
  static const seconds = 120;
  int maxSeconds = seconds;
  int minutes = 2;
  int hour = 1;

  // late Timer _timer;
  // void answered() {
  //   if (quizIndex + 1 == widget.quizzes.length) {
  //     return;
  //   }
  //   setState(() {
  //     quizIndex += 1;
  //   });
  // }

  @override
  void initState() {
    // startTimer();
    super.initState();
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  bool isSubmit = false;
  List<int> selectedAnswers = [];
  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return WillPopScope(
      onWillPop: () {
        return showWarning();
      },
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy < sensitivity) {
            // showAllQuestions();
          } else {
            return;
          }
        },
        child: StreamBuilder<List<Quiz>?>(
            stream: _quizServices.getQuizzes(widget.quizID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                data!.shuffle();
                final correct = data.map((e) => e.option1).toList();
                final option2 = data.map((e) => e.option2).toList();
                final option3 = data.map((e) => e.option3).toList();
                final option4 = data.map((e) => e.option4).toList();
                final questionID = data.map((e) => e.questionID).toList();
                final questionList = data.map((e) => e.question).toList();
                print(correct);
                List<String> answers = [
                  correct[quizIndex].toString(),
                  option2[quizIndex].toString(),
                  option3[quizIndex].toString(),
                  option4[quizIndex].toString()
                ];
                answers.shuffle();
                print(answers);
                String questions = questionList[quizIndex].toString();
                return StreamBuilder<List<AnswerPreviewModel>>(
                    stream: _quizServices.readAnswerPreview(
                        FirebaseAuth.instance.currentUser!.uid.toString(),
                        widget.quizID,
                        questionID[quizIndex].toString()),
                    builder: (context, snapshot) {
                      var dataAnswer = snapshot.data;
                      List<String?> myAnswer =
                          dataAnswer!.map((e) => e.answer).toList();
                      var selectedAnswer = myAnswer[quizIndex];
                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.blue[900],
                          title: Text(
                            widget.title,
                          ),
                        ),
                        body: isSubmit
                            ? Done(
                                doneText: 'Congratulations! you made it!..',
                                score: '100',
                                quizName: widget.title,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: ListView(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            HapticFeedback.vibrate();
                                            // showAllQuestions();
                                          },
                                          child: Text(
                                            'Quiz ${quizIndex + 1} out of ${data.length}',
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        Text(
                                          maxSeconds.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Questions(
                                            questionNumber: quizIndex + 1,
                                            questions: questions.toString()),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ...answers.map((e) => AnswerTiles(
                                            e, data, selectedAnswer)),
                                      ],
                                    )),
                                    quizIndex + 1 == data.length
                                        ? SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blue[900]),
                                              onPressed: () {
                                                setState(() {
                                                  isSubmit = true;
                                                  quizIndex = 0;
                                                });
                                              },
                                              child: const Text('Submit'),
                                            ),
                                          )
                                        : SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blue[900]),
                                              onPressed: () {
                                                setState(() {
                                                  if (data.length ==
                                                      quizIndex + 1) {
                                                    quizIndex = 0;
                                                  }
                                                  quizIndex += 1;
                                                });
                                              },
                                              child: const Text('Next'),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                      );
                    });
              }

              return const SomethingWrong();
            }),
      ),
    );
  }

  // Future showAllQuestions() => showModalBottomSheet(
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topRight: Radius.circular(20), topLeft: Radius.circular(20))),
  //     enableDrag: true,
  //     context: context,
  //     builder: (context) => Container(
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: ListView.builder(
  //           itemCount: widget.quizzes.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return widget.quizzes
  //                 .map((e) => createTiles(e, index))
  //                 .toList()[index];
  //           },
  //         ),
  //       ),
  //     ));

  Widget createTiles(Map<String, Object> e, int index) {
    return Card(
      child: ListTile(
        onTap: () {
          setState(() {
            Navigator.pop(context);
            quizIndex = index;
          });
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              maxLines: 20,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.8), fontSize: 13),
                  text:
                      '${index + 1}. ${'${e['Question'].toString().substring(0, 50)}...'}'),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> showWarning() async {
    showDialog(
        context: (context),
        builder: (context) => AlertDialog(
              content:
                  const Text('Please make sure you answer the quiz completely '
                      'before you leave.'),
              actions: [
                TextButton(
                    onPressed: () {
                      quizIndex = 0;
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Understand')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'))
              ],
            ));
    return true;
  }

  // void startTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       maxSeconds--;
  //     });
  //   });
  // }

  AnswerTiles(String e, List<Quiz?> data, [String? selectedAnswer]) {
    return InkWell(
      splashColor: Colors.blue.shade100,
      onTap: () async {
        print(e);
        print(data[quizIndex]);
        var quizPreviewDetails = {
          'quizID': widget.quizID,
          'questionID': data[quizIndex]!.questionID.toString(),
          'answer': e,
        };

        await _quizServices.addQuizPreview(
            quizPreviewDetails,
            widget.quizID,
            FirebaseAuth.instance.currentUser!.uid,
            data[quizIndex]!.questionID.toString());
      },
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: e == selectedAnswer ? Colors.blue : Colors.transparent,
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(padding: const EdgeInsets.all(15), child: Text(e)),
      ),
    );
  }
}
