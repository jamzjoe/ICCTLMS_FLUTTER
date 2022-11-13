part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class StartQuiz extends QuizEvent{
  @override
  List<Object?> get props => [];
}


class EndQuiz extends QuizEvent{
  final String score;

  const EndQuiz(this.score);
  @override
  List<Object?> get props => [score];
}
