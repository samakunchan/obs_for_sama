part of 'current_source_bloc.dart';

sealed class CurrentSourceState extends Equatable {
  const CurrentSourceState();
}

final class CurrentSourceInitial extends CurrentSourceState {
  @override
  List<Object> get props => [];
}

final class CurrentSourceIsLoading extends CurrentSourceState {
  @override
  List<Object> get props => [];
}

final class CurrentSourceWithValue extends CurrentSourceState {
  const CurrentSourceWithValue({required this.currentSceneName});
  final String currentSceneName;

  @override
  List<Object> get props => [currentSceneName];
}
