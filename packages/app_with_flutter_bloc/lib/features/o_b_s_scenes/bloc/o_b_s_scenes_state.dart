part of 'o_b_s_scenes_bloc.dart';

abstract class OBSScenesState extends Equatable {
  const OBSScenesState();
}

final class OBSScenesInitial extends OBSScenesState {
  @override
  List<Object> get props => [];
}

final class OBSScenesIsLoading extends OBSScenesState {
  @override
  String toString() {
    return 'OBSScenesIsLoading';
  }

  @override
  List<Object> get props => [];
}

final class OBSScenesHasError extends OBSScenesState {
  const OBSScenesHasError({required this.message});
  final String message;

  @override
  String toString() {
    return 'OBSScenesHasError - $message';
  }

  @override
  List<Object> get props => [message];
}

final class OBSScenesHasValues extends OBSScenesState {
  const OBSScenesHasValues({required this.scenes, required this.currentScene});
  final List<Scene> scenes;
  final String currentScene;

  @override
  String toString() {
    return 'OBSScenesHasValues - $scenes with current scene = $currentScene';
  }

  @override
  List<Object> get props => [scenes, currentScene];
}
