import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_sources/repositories/sources_repository.dart';
import 'package:obs_websocket/obs_websocket.dart';

part 'o_b_s_sources_event.dart';
part 'o_b_s_sources_state.dart';

class OBSSourcesBloc extends Bloc<OBSSourcesEvent, OBSSourcesState> {
  OBSSourcesBloc() : super(OBSSourcesInitial()) {
    on<OBSSourcesFetched>(_onFetchOBSSources);
  }

  Future<void> _onFetchOBSSources(OBSSourcesFetched event, Emitter<OBSSourcesState> emit) async {
    emit(OBSSourcesIsLoading());
    final List<SceneItemDetail> response = await SourcesRepository.getListSourcesByCurrentScene(
      currentSceneName: event.sceneName,
    );
    emit(OBSSourcesHasValues(sources: response, currentScene: event.sceneName));
  }
}
