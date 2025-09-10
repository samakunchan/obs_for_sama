import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obs_websocket.dart';

import '../../../core/index.dart';
import '../../../core/services/client_service.dart';
import '../repositories/sources_repository.dart';

part 'o_b_s_sources_event.dart';
part 'o_b_s_sources_state.dart';

class OBSSourcesBloc extends Bloc<OBSSourcesEvent, OBSSourcesState> {
  OBSSourcesBloc() : super(OBSSourcesInitial()) {
    on<OBSSourcesFetched>(_onFetchOBSSources);
  }

  Future<void> _onFetchOBSSources(OBSSourcesFetched event, Emitter<OBSSourcesState> emit) async {
    emit(OBSSourcesIsLoading());
    final Either<Failure, List<SceneItemDetail>> response = await ClientService.baseRequest<List<SceneItemDetail>>(
      getConcrete: () => SourcesRepository.getListSourcesByCurrentScene(
        currentSceneName: event.sceneName,
      ),
    );

    switch (response) {
      case Left():
        emit(OBSSourcesHasError(message: response.value.message));
      case Right():
        emit(OBSSourcesHasValues(sources: response.value, currentScene: event.sceneName));
    }
  }
}
