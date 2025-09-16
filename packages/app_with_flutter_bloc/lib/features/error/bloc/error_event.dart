part of 'error_bloc.dart';

abstract class ErrorEvent extends Equatable {
  const ErrorEvent();
}

final class ErrorEmitted extends ErrorEvent {
  const ErrorEmitted({required this.errorInstance});
  final Failure errorInstance;

  @override
  List<Object> get props => [errorInstance];
}

final class ErrorReseted extends ErrorEvent {
  @override
  List<Object> get props => [];
}
