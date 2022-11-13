part of 'quiz_bloc.dart';


class QuizState extends Equatable {
  const QuizState();
  
  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {
}
class QuizLoading extends QuizState{
}
class QuizStartState extends QuizState{
}
class QuizEndState extends QuizState {
  final String score;
  final String total;

  const QuizEndState(this.score, this.total);

}