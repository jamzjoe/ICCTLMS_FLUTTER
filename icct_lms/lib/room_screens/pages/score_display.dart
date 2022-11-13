import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ScoreDisplay extends StatefulWidget {
  const ScoreDisplay(
      {Key? key,
      required this.score,
      required this.total,
      required this.title,
      required this.description,
      required this.duration,
      required this.professor})
      : super(key: key);
  final String score;
  final String total;
  final String title;
  final String description;
  final List<String> duration;
  final String professor;
  @override
  State<ScoreDisplay> createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DottedBorder(
                strokeWidth: 1,
                color: Colors.black54,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.score}/${widget.total}',
                            style: const TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                      Text('Quiz Title: ${widget.title}'),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Quiz Description:'),
                      Text(widget.description),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Time: ${widget.duration[0]}:${widget.duration[1]}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Professor: ${widget.professor}' ?? 'Professor'),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
