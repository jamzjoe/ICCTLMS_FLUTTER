import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icct_lms/quiz/add_QandA.dart';
import 'package:icct_lms/quiz/add_question.dart';
import 'package:icct_lms/services/quizzes.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:uuid/uuid.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key, required this.roomID, required this.professor});
  final String roomID;
  final String professor;
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> with TickerProviderStateMixin {
  QuizServices databaseService = QuizServices();
  final _formKey = GlobalKey<FormState>();
  TimeOfDay time = const TimeOfDay(hour: 01, minute: 30);
  String quizTitle = '';
  String quizDesc = '';

  bool isLoading = false;
  int hours = 1;
  int minutes = 0;
  String quizId = '';
  var QuizType = [
    'Multiple Choice',
    'Question and Answer'
  ];
  String? selectedType = 'Multiple Choice';
  late DateTime selectedDate;
  final _countController = TextEditingController();
  createQuiz() {
    quizId = const Uuid().v4().toString();
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> quizData = {
        "quizTitle": quizTitle.toString(),
        "quizDesc": quizDesc.toString(),
        "roomID": widget.roomID,
        "quizType": selectedType,
        'quizID': quizId,
        "time_duration": '$hours:$minutes',
        "due_date": selectedDate,
        "professor": widget.professor,
        "created": FieldValue.serverTimestamp()
      };

      databaseService.addQuizData(quizData, quizId.toString()).then((value) {
        setState(() {
          isLoading = false;
        });
        if(selectedType == 'Multiple Choice'){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
        }else{
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => QuestionAndAnswer
                (quizID: quizId,)));
        }


      });
    }
  }

  @override
  void initState() {
    selectedDate = DateTime.now();
    selectedType = QuizType[0];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black54,
        ),
        title: const Text(
          'Create Quiz',
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        //brightness: Brightness.li,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Quiz Title" : null,
                      decoration: const InputDecoration(hintText: "Quiz Title"),
                      onChanged: (val) {
                        quizTitle = val;
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Quiz Description" : null,
                      decoration:
                          const InputDecoration(hintText: "Quiz Description"),
                      onChanged: (val) {
                        quizDesc = val;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            onChanged: (String? value) {
                              setState(() {
                                selectedType = value!;
                              });
                            },
                            value: selectedType,
                            isExpanded: true,
                            icon: const Icon(
                                Icons.keyboard_arrow_down_outlined),
                            items: QuizType.map((String each) {
                              return DropdownMenuItem(
                                  value: each, child: Text(each));
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Duration: $hours:$minutes'),
                                Text(
                                    'Date: ${selectedDate.toString().substring(0, 10)}')
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            const Text('Hour/s'),
                            NumberPicker(
                                axis: Axis.horizontal,
                                minValue: 0,
                                maxValue: 24,
                                value: hours,
                                onChanged: (value) => setState(() {
                                      hours = value;
                                    })),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Minute/s'),
                            NumberPicker(
                                axis: Axis.horizontal,
                                minValue: 0,
                                maxValue: 60,
                                value: minutes,
                                onChanged: (value) => setState(() {
                                      minutes = value;
                                    })),
                          ],
                        ),
                      ],
                    ),
                    CalendarDatePicker(
                        initialDate: selectedDate,
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2050, 20, 19),
                        onDateChanged: (value) => setState(() {
                              selectedDate = value;
                            })),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  createQuiz();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Text(
                    "Create Quiz",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void show() async {
    final result = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 1, minute: 10));
    setState(() {
      _countController.text =
          '${result!.hour.toString()}:${result.minute.toString()}';
    });
  }
}
