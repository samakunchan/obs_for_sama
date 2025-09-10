part of 'sound_bloc.dart';

abstract class SoundEvent extends Equatable {
  const SoundEvent();
}

final class SoundInitialized extends SoundEvent {
  const SoundInitialized({required this.isSoundMuted});
  final bool isSoundMuted;
  @override
  List<Object> get props => [isSoundMuted];
}

final class SoundConfigured extends SoundEvent {
  @override
  List<Object> get props => [];
}

final class SoundReseted extends SoundEvent {
  @override
  List<Object> get props => [];
}

final class SoundToggled extends SoundEvent {
  const SoundToggled({required this.soundName});
  final String soundName;
  @override
  List<Object> get props => [soundName];
}
