part of 'answers_bloc.dart';

abstract class AnswersState extends Equatable {
  const AnswersState();
  
  @override
  List<Object> get props => [];
}

class AnswersInitial extends AnswersState {}
