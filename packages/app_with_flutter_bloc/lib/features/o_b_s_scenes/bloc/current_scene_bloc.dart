import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/index.dart';
import '../../../core/services/client_service.dart';
import '../repositories/scenes_repository.dart';

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
    final Either<Failure, String?> response = await ClientService.baseRequest<String?>(
      getConcrete: ScenesRepository.getCurrentScene,
    );

    switch (response) {
      case Right():
        if (response.value != null) {
          emit(CurrentSceneWithValue(currentScene: response.value!));
        }
    }
  }

  Future<void> _onCurrentSceneChanged(CurrentSceneChanged event, Emitter<CurrentSceneState> emit) async {
    if (kDebugMode) {
      print('J‘effectue un changement de scene vers "${event.sceneName.toUpperCase()}"');
    }
    emit(CurrentSceneIsLoading());
    final Either<Failure, String> response = await ClientService.baseRequest<String>(
      getConcrete: () => ScenesRepository.onChangeScene(sceneName: event.sceneName),
    );

    switch (response) {
      case Right():
        emit(CurrentSceneWithValue(currentScene: response.value));
    }
  }
}
