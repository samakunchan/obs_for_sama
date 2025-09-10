part of 'title_bloc.dart';

abstract class TitleEvent extends Equatable {
  const TitleEvent();
}

final class TitleChanged extends TitleEvent {
  const TitleChanged({required this.title});
  final String title;

  @override
  List<Object> get props => [title];
}
