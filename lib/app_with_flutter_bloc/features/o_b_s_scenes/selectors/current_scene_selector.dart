import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_scenes/bloc/current_scene_bloc.dart';

class CurrentSceneSelector extends StatelessWidget {
  const CurrentSceneSelector({required this.value, super.key});
  final Widget Function(String) value;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CurrentSceneBloc, CurrentSceneState, String>(
      selector: _whenCurrentSceneHasConfigurationActive,
      builder: (_, String scene) => value(scene),
    );
  }

  static String _whenCurrentSceneHasConfigurationActive(CurrentSceneState state) {
    switch (state) {
      case CurrentSceneWithValue():
        return state.currentScene;
      default:
        return 'Unknown scene name';
    }
  }
}
