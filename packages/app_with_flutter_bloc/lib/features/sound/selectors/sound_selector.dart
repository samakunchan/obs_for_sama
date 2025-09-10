import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/sound_bloc.dart';

class SoundSelector extends StatelessWidget {
  const SoundSelector({required this.value, super.key});
  final Widget Function(String?) value;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SoundBloc, SoundState, String?>(
      selector: _whenSoundHasConfigurationActive,
      builder: (_, String? soundName) => value(soundName),
    );
  }

  static String? _whenSoundHasConfigurationActive(SoundState state) {
    switch (state) {
      case SoundHasConfiguration():
        return state.correctSoundName;
      default:
        return null;
    }
  }
}
