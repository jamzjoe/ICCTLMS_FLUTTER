import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icct_lms/components/done.dart';
import 'package:icct_lms/quiz/answer.dart';
import 'package:icct_lms/quiz/questions.dart';

class QuizRoom extends StatefulWidget {
  const QuizRoom({Key? key, required this.title, required this.quizzes}) : super(key: key);
  final String title;
  final List<Map<String, Object>> quizzes;
  @override
  State<QuizRoom> createState() => _QuizRoomState();
}


var quizIndex = 0;
class _QuizRoomState extends State<QuizRoom> {

  static const seconds = 120;
  int maxSeconds = seconds;
  int minutes = 2;
  int hour = 1;

  late Timer _timer;
  void answered() {
    if(quizIndex+1 == widget.quizzes.length){
      return;
    }
    setState(() {
      quizIndex += 1;
    });
  }
  @override
  void initState() {
    startTimer();
    super.initState();
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  bool isSubmit = false;
  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onVerticalDragUpdate: (details){
        int sensitivity = 8;
        if(details.delta.dy < sensitivity){
          showAllQuestions();
        }else{
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(
            widget.title,
          ),
        ),
        body: isSubmit ?  Done(doneText: 'Congratulations! you made it!..',
          score:
        widget
            .quizzes.length.toString(), quizName: widget.title,) :
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: ListView(
                children: [
                  GestureDetector(
                    onTap: (){
                      HapticFeedback.vibrate();
                      showAllQuestions();
                    },
                    child: Text('Quiz ${quizIndex+1} out of ${widget.quizzes
                        .length}',
                      textAlign:
                    TextAlign.end,),
                  ),
                  Text(maxSeconds.toString(), textAlign: TextAlign.center,),
                  const SizedBox(height: 10,),
                  Questions(questionNumber: quizIndex+1, questions: widget
                      .quizzes[quizIndex]['Question']
                      .toString()),
                  const SizedBox(height: 20,),
                  ...(widget.quizzes[quizIndex]['answers'] as List<String>).map((e)
                  => Answers(choices: e, answered:answered)).toList()
                ],
              )),
              quizIndex+1 == widget.quizzes.length ? Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900]
                  ),
                  onPressed: (){
                    setState(() {
                      isSubmit = true;
                      quizIndex = 0;
                    });
                  },
                  child: Text('Submit'),
                ),
              ) :
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900]
                  ),
                  onPressed: answered,
                  child: Text('Next'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future showAllQuestions() => showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft:
      Radius.circular(20))
    ),
      enableDrag: true,
      context: context,
  builder: (context) => Container(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: widget.quizzes.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.quizzes.map((e) => createTiles(e, index)).toList()[index];
        },
      ),
    ),
  ));



  Widget createTiles(Map<String, Object> e, int index) {
  return Card(
    child: ListTile(
      onTap: (){
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
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 13
                ),
                text: '${index+1}. ${'${e['Question'].toString().substring(0,
                    50)}...'}'
                
              ),
          )
        ],
      ),
    ),
  );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        maxSeconds--;
      });
    });

  }
}
