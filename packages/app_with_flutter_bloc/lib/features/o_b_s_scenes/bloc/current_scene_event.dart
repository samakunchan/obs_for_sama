part of 'current_scene_bloc.dart';

abstract class CurrentSceneEvent extends Equatable {
  const CurrentSceneEvent();
}

final class CurrentSceneInit extends CurrentSceneEvent {
  @override
  List<Object?> get props => [];
}

final class CurrentSceneChanged extends CurrentSceneEvent {
  const CurrentSceneChanged({required this.sceneName});
  final String sceneName;

  @override
  List<Object> get props => [sceneName];
}
