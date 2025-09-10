part of 'o_b_s_sources_bloc.dart';

abstract class OBSSourcesEvent extends Equatable {
  const OBSSourcesEvent();
}

final class OBSSourcesFetched extends OBSSourcesEvent {
  const OBSSourcesFetched({required this.sceneName});
  final String sceneName;
  @override
  List<Object> get props => [sceneName];
}

final class OBSSourcesReseted extends OBSSourcesEvent {
  @override
  List<Object> get props => [];
}
