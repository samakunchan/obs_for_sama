import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obs_websocket.dart';

import '../../../core/index.dart';
import '../../../core/services/client_service.dart';
import '../repositories/sources_repository.dart';

part 'current_source_event.dart';
part 'current_source_state.dart';

class CurrentSourceBloc extends Bloc<CurrentSourceEvent, CurrentSourceState> {
  CurrentSourceBloc() : super(CurrentSourceInitial()) {
    on<CurrentSourceChanged>(_onCurrentSourceChanged);
  }

  Future<void> _onCurrentSourceChanged(CurrentSourceChanged event, Emitter<CurrentSourceState> emit) async {
    if (kDebugMode) {
      print('J‘effectue un changement de source vers "${event.source.sourceName.toUpperCase()}"');
    }
    emit(CurrentSourceIsLoading());
    final Either<Failure, List<SceneItemDetail>> response = await ClientService.baseRequest<List<SceneItemDetail>>(
      getConcrete: () => SourcesRepository.toogleActiveSource(
        source: event.source,
        currentSceneName: event.sceneName,
      ),
    );

    switch (response) {
      case Right():
        emit(
          CurrentSourceWithValue(
            currentSceneName: event.sceneName,
          ),
        );
    }
    await SourcesRepository.toogleActiveSource(
      source: event.source,
      currentSceneName: event.sceneName,
    );
  }
}
