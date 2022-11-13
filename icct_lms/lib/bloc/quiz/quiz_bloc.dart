import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:icct_lms/models/ticker.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial
    ()) {

    on<StartQuiz>((event, emit)async {
      emit(QuizLoading());
      emit(QuizStartState());
      /// makes the subscription listen to TimerTicked state

    });

    on<LoadQuiz>((event, emit)async {
      emit(QuizLoading());

    });

    on<EndQuiz>((event, emit)async {
      emit(QuizEndState(event.score, event.total));
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }

}
