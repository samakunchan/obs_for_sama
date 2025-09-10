part of 'o_b_s_status_bloc.dart';

abstract class OBSStatusState extends Equatable {
  const OBSStatusState();
}

final class OBSStatusInitial extends OBSStatusState {
  @override
  List<Object> get props => [];
}

final class OBSStatusIsStarting extends OBSStatusState {
  @override
  String toString() {
    return 'OBSStatusIsStarting ';
  }

  @override
  List<Object> get props => [];
}

final class OBSStatusIsStopping extends OBSStatusState {
  @override
  String toString() {
    return 'OBSStatusIsStopping ';
  }

  @override
  List<Object> get props => [];
}

final class OBSStatusHasError extends OBSStatusState {
  const OBSStatusHasError({required this.message});
  final String message;

  @override
  String toString() {
    return 'OBSStatusHasError - $message';
  }

  @override
  List<Object> get props => [message];
}

final class OBSStatusHasStarted extends OBSStatusState {
  @override
  String toString() {
    return 'OBSStatusHasStarted';
  }

  @override
  List<Object> get props => [];
}

final class OBSStatusHasStopped extends OBSStatusState {
  @override
  String toString() {
    return 'OBSStatusHasStopped';
  }

  @override
  List<Object> get props => [];
}
