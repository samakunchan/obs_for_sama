part of 'current_scene_bloc.dart';

abstract class CurrentSceneEvent extends Equatable {
  const CurrentSceneEvent();
}

final class CurrentSceneInit extends CurrentSceneEvent {
  @override
  List<Object?> get props => [];
}

final class CurrentSceneChanged extends CurrentSceneEvent {
  const CurrentSceneChanged({required this.scene});
  final Scene scene;

  @override
  List<Object> get props => [scene];
}
