import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_scenes/models/o_b_s_scene_model.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_scenes/repositories/scenes_repository.dart';
import 'package:obs_websocket/obs_websocket.dart';

part 'o_b_s_scenes_event.dart';
part 'o_b_s_scenes_state.dart';

class OBSScenesBloc extends Bloc<OBSScenesEvent, OBSScenesState> {
  OBSScenesBloc() : super(OBSScenesInitial()) {
    on<OBSScenesFetched>(_onFetchOBSScenes);

    add(OBSScenesFetched());
  }

  Future<void> _onFetchOBSScenes(OBSScenesFetched event, Emitter<OBSScenesState> emit) async {
    emit(OBSScenesIsLoading());
    final OBSSceneModel response = await ScenesRepository.getListScenes();
    emit(OBSScenesHasValues(scenes: response.scenes, currentScene: response.currentScene));
  }
}
