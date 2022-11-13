import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'answers_event.dart';
part 'answers_state.dart';

class AnswersBloc extends Bloc<AnswersEvent, AnswersState> {
  AnswersBloc() : super(AnswersInitial()) {
    on<AnswersEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
