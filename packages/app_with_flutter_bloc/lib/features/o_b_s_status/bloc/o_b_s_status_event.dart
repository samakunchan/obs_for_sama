part of 'o_b_s_status_bloc.dart';

abstract class OBSStatusEvent extends Equatable {
  const OBSStatusEvent();
}

final class OBSStatusStreamStarted extends OBSStatusEvent {
  @override
  List<Object> get props => [];
}

final class OBSStatusStreamStopped extends OBSStatusEvent {
  @override
  List<Object> get props => [];
}

final class OBSStatusStreamChanged extends OBSStatusEvent {
  const OBSStatusStreamChanged({required this.statusStream});
  final StatusStream statusStream;
  @override
  List<Object> get props => [statusStream];
}
