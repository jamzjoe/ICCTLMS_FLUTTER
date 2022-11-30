import 'package:flutter/material.dart';
class QuestionAndAnswer extends StatefulWidget {
  const QuestionAndAnswer({Key? key, required this.quizID}) : super(key: key);
  final String quizID;
  @override
  State<QuestionAndAnswer> createState() => _QuestionAndAnswerState();
}

class _QuestionAndAnswerState extends State<QuestionAndAnswer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question and Answer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextFormField(
              maxLines: null,
              decoration: InputDecoration(
                label: Text('Questions')
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                label: Text('Correct Answer'),
                border: OutlineInputBorder()
              ),
              maxLines: null,
            ),
            OutlinedButton(onPressed: (){}, child: Text('Submit'))
          ],
        ),
      ),
    );
  }
}
