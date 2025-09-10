import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obs_websocket.dart';

import '../../../core/index.dart';
import '../../../core/services/client_service.dart';
import '../models/o_b_s_scene_model.dart';
import '../repositories/scenes_repository.dart';

part 'o_b_s_scenes_event.dart';
part 'o_b_s_scenes_state.dart';

class OBSScenesBloc extends Bloc<OBSScenesEvent, OBSScenesState> {
  OBSScenesBloc() : super(OBSScenesInitial()) {
    on<OBSScenesFetched>(_onFetchOBSScenes);

    add(OBSScenesFetched());
  }

  Future<void> _onFetchOBSScenes(OBSScenesFetched event, Emitter<OBSScenesState> emit) async {
    emit(OBSScenesIsLoading());
    final Either<Failure, OBSSceneModel> response = await ClientService.baseRequest<OBSSceneModel>(
      getConcrete: ScenesRepository.getListScenes,
    );

    switch (response) {
      case Left():
        emit(OBSScenesHasError(message: response.value.message));
      case Right():
        emit(OBSScenesHasValues(scenes: response.value.scenes, currentScene: response.value.currentScene));
    }
  }
}
