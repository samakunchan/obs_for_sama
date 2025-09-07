part of 'current_source_bloc.dart';

sealed class CurrentSourceEvent extends Equatable {
  const CurrentSourceEvent();
}

final class CurrentSourceChanged extends CurrentSourceEvent {
  const CurrentSourceChanged({required this.source, required this.sceneName});
  final SceneItemDetail source;
  final String sceneName;

  @override
  List<Object> get props => [source, sceneName];
}
