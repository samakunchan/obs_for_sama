part of 'current_scene_bloc.dart';

abstract class CurrentSceneState extends Equatable {
  const CurrentSceneState();
}

final class CurrentSceneInitial extends CurrentSceneState {
  @override
  List<Object> get props => [];
}

final class CurrentSceneIsLoading extends CurrentSceneState {
  @override
  List<Object> get props => [];
}

final class CurrentSceneWithValue extends CurrentSceneState {
  const CurrentSceneWithValue({required this.currentScene});
  final String currentScene;

  @override
  List<Object> get props => [currentScene];
}
