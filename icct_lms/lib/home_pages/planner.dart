import 'package:flutter/material.dart';
import 'package:icct_lms/quiz/quiz_room.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

var title = ['Quiz 1', 'Quiz 2'];
var quizzes = [
  {
    'Question':
        'Host A receives a frame and discards it after determining it is corrupt. Which OSI layer checks frames for errors??',
    'answers': ['Application', 'Network', 'Physical']
  },
  {
    'Question':
        "No matter how it's configured, a single switch port is considered what?",
    'answers': [
      'A separate unicast domain',
      'A separate broadcast domain',
      'A separate multicast domain'
    ]
  },
  {
    'Question':
        'Identify which of the services below uses both TCP and UDP ports.',
    'answers': ['FTP', 'DNS', 'SSH']
  },
  {
    'Question':
        'A router with a BGP autonomous system number of 65001 is peered with another router with the same BGP AS. Which of the following is true?',
    'answers': [
      'The ebgp multihop command must be configured to reach an established state.',
      'A BGP connection will be established, but no traffic will traverse the connection.'
    ]
  },
  {
    'Question': 'After carefully examining the network diagram above, select the correct statement regarding broadcast and collision domains.',
    'answers': [
      'There is one broadcast domain and seven collision domains.',
      'There are two broadcast domains and five collision domains'
    ]
  },
  {
    'Question':
    'Host A receives a frame and discards it after determining it is corrupt. Which OSI layer checks frames for errors??',
    'answers': ['Application', 'Network', 'Physical']
  },
  {
    'Question':
    "No matter how it's configured, a single switch port is considered what?",
    'answers': [
      'A separate unicast domain',
      'A separate broadcast domain',
      'A separate multicast domain'
    ]
  },
  {
    'Question':
    'Identify which of the services below uses both TCP and UDP ports.',
    'answers': ['FTP', 'DNS', 'SSH']
  },
  {
    'Question':
    'A router with a BGP autonomous system number of 65001 is peered with another router with the same BGP AS. Which of the following is true?',
    'answers': [
      'The ebgp multihop command must be configured to reach an established state.',
      'A BGP connection will be established, but no traffic will traverse the connection.'
    ]
  },
  {
    'Question': 'After carefully examining the network diagram above, select the correct statement regarding broadcast and collision domains.',
    'answers': [
      'There is one broadcast domain and seven collision domains.',
      'There are two broadcast domains and five collision domains'
    ]
  },
];

class _PlannerScreenState extends State<PlannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: title.map(createTiles).toList(),
      ),
    );
  }

  Widget createTiles(String e) => Card(
        child: ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuizRoom(title: e, quizzes: quizzes))),
          title: Text(e),
        ),
      );
}
