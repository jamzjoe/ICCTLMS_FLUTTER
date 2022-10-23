part of 'posts_bloc.dart';

@immutable
abstract class PostsState extends Equatable {}

class PostsInitial extends PostsState {
  @override
  List<Object?> get props => [];
}
