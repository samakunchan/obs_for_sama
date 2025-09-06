part of 'error_bloc.dart';

abstract class ErrorEvent extends Equatable {
  const ErrorEvent();
}

final class ErrorEmitted extends ErrorEvent {
  const ErrorEmitted({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

final class ErrorReseted extends ErrorEvent {
  @override
  List<Object> get props => [];
}
