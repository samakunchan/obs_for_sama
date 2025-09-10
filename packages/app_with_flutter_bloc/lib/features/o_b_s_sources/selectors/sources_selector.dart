import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obs_websocket.dart';

import '../bloc/current_source_bloc.dart';
import '../bloc/o_b_s_sources_bloc.dart';

class SourcesSelector extends StatelessWidget {
  const SourcesSelector({required this.values, super.key});
  final Widget Function(List<SceneItemDetail>) values;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentSourceBloc, CurrentSourceState>(
      listener: (BuildContext context, CurrentSourceState state) {
        if (state is CurrentSourceWithValue) {
          context.read<OBSSourcesBloc>().add(OBSSourcesFetched(sceneName: state.currentSceneName));
        }
      },
      child: BlocSelector<OBSSourcesBloc, OBSSourcesState, List<SceneItemDetail>>(
        selector: _whenOBSSourcesHasConfigurationActive,
        builder: (_, List<SceneItemDetail> scenes) => values(scenes),
      ),
    );
  }

  static List<SceneItemDetail> _whenOBSSourcesHasConfigurationActive(OBSSourcesState state) {
    switch (state) {
      case OBSSourcesHasValues():
        return state.sources;
      default:
        return List<SceneItemDetail>.empty(growable: true);
    }
  }
}
