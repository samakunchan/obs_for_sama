part of 'o_b_s_sources_bloc.dart';

abstract class OBSSourcesState extends Equatable {
  const OBSSourcesState();
}

final class OBSSourcesInitial extends OBSSourcesState {
  @override
  List<Object> get props => [];
}

final class OBSSourcesIsLoading extends OBSSourcesState {
  @override
  String toString() {
    return 'OBSSourcesIsLoading';
  }

  @override
  List<Object> get props => [];
}

final class OBSSourcesHasError extends OBSSourcesState {
  const OBSSourcesHasError({required this.message});
  final String message;

  @override
  String toString() {
    return 'OBSSourcesHasError - $message';
  }

  @override
  List<Object> get props => [message];
}

final class OBSSourcesHasValues extends OBSSourcesState {
  const OBSSourcesHasValues({required this.sources, required this.currentScene});
  final List<SceneItemDetail> sources;
  final String currentScene;

  @override
  String toString() {
    return 'OBSSourcesHasValues - $sources with current scene = $currentScene';
  }

  @override
  List<Object> get props => [sources, currentScene];
}
