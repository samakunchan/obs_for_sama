part of 'error_bloc.dart';

abstract class ErrorState extends Equatable {
  const ErrorState();
}

final class ErrorInitial extends ErrorState {
  @override
  List<Object> get props => [];
}

final class ErrorLoading extends ErrorState {
  @override
  String toString() {
    return 'ErrorLoading';
  }

  @override
  List<Object> get props => [];
}

final class ErrorMessageDisplayed extends ErrorState {
  const ErrorMessageDisplayed({required this.message});
  final String message;

  @override
  String toString() {
    return 'ErrorMessageDisplayed - $message';
  }

  @override
  List<Object> get props => [message];
}
