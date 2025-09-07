import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_scenes/repositories/scenes_repository.dart';

part 'current_scene_event.dart';
part 'current_scene_state.dart';

class CurrentSceneBloc extends Bloc<CurrentSceneEvent, CurrentSceneState> {
  CurrentSceneBloc() : super(CurrentSceneInitial()) {
    on<CurrentSceneInit>(_onInit);
    on<CurrentSceneChanged>(_onCurrentSceneChanged);
    add(CurrentSceneInit());
  }

  Future<void> _onInit(CurrentSceneInit event, Emitter<CurrentSceneState> emit) async {
    if (kDebugMode) {
      print('J‘initialise la scene en cours.');
    }
    emit(CurrentSceneIsLoading());
    final String? response = await ScenesRepository.getCurrentScene();
    if (response != null) {
      emit(CurrentSceneWithValue(currentScene: response));
    }
  }

  Future<void> _onCurrentSceneChanged(CurrentSceneChanged event, Emitter<CurrentSceneState> emit) async {
    if (kDebugMode) {
      print('J‘effectue un changement de scene vers "${event.sceneName.toUpperCase()}"');
    }
    emit(CurrentSceneIsLoading());
    final String response = await ScenesRepository.onChangeScene(sceneName: event.sceneName);
    emit(CurrentSceneWithValue(currentScene: response));
  }
}
