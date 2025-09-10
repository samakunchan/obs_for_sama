part of 'title_bloc.dart';

abstract class TitleState extends Equatable {
  const TitleState();
}

final class TitleInitial extends TitleState {
  @override
  List<Object> get props => [];
}

final class TitleWithValue extends TitleState {
  const TitleWithValue({required this.title});
  final String title;

  @override
  String toString() {
    return 'TitleWithValue - $title';
  }

  @override
  List<Object> get props => [title];
}
