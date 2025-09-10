import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obs_websocket.dart';

import '../bloc/o_b_s_scenes_bloc.dart';

class ScenesSelector extends StatelessWidget {
  const ScenesSelector({required this.values, super.key});
  final Widget Function(List<Scene>) values;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OBSScenesBloc, OBSScenesState, List<Scene>>(
      selector: _whenOBSScenesHasConfigurationActive,
      builder: (_, List<Scene> scenes) => values(scenes),
    );
  }

  static List<Scene> _whenOBSScenesHasConfigurationActive(OBSScenesState state) {
    switch (state) {
      case OBSScenesHasValues():
        return state.scenes;
      default:
        return List<Scene>.empty(growable: true);
    }
  }
}
