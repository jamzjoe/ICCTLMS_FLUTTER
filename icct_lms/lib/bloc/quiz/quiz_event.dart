part of 'quiz_bloc.dart';

class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class StartQuiz extends QuizEvent{
  final int duration;

  const StartQuiz(this.duration);
  @override
  List<Object?> get props => [];
}

class LoadQuiz extends QuizEvent{

}

class EndQuiz extends QuizEvent{
  final String score;
  final String total;

  const EndQuiz(this.score, this.total);
  @override
  List<Object?> get props => [score];
}

