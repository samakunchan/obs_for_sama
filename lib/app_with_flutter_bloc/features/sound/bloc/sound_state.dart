part of 'sound_bloc.dart';

abstract class SoundState extends Equatable {
  const SoundState();
}

final class SoundInitial extends SoundState {
  @override
  List<Object> get props => [];
}

final class SoundIsLoading extends SoundState {
  @override
  String toString() {
    return 'SoundIsLoading';
  }

  @override
  List<Object> get props => [];
}

final class SoundHasError extends SoundState {
  const SoundHasError({required this.message});
  final String message;

  @override
  String toString() {
    return 'SoundHasError - $message';
  }

  @override
  List<Object> get props => [message];
}

final class SoundHasConfiguration extends SoundState {
  const SoundHasConfiguration({required this.correctSoundName});

  final String correctSoundName;

  @override
  String toString() {
    return 'SoundHasConfiguration - $correctSoundName';
  }

  @override
  List<Object> get props => [correctSoundName];
}

final class SoundHasNewStatus extends SoundState {
  const SoundHasNewStatus({required this.isSoundActive, required this.correctSoundName});

  final bool isSoundActive;
  final String correctSoundName;

  @override
  String toString() {
    return 'SoundHasNewStatus - $isSoundActive';
  }

  @override
  List<Object> get props => [isSoundActive, correctSoundName];
}
