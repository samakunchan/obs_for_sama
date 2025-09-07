import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_sources/repositories/sources_repository.dart';
import 'package:obs_websocket/obs_websocket.dart';

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
    final List<SceneItemDetail> response = await SourcesRepository.toogleActiveSource(
      source: event.source,
      currentSceneName: event.sceneName,
    );
    emit(
      CurrentSourceWithValue(
        currentSceneName: event.sceneName,
      ),
    );
  }
}
