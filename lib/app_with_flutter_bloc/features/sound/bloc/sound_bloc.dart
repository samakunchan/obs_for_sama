import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/services/server_service.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/sound/repositories/sound_repository.dart';
import 'package:obs_for_sama/project_app.dart';
import 'package:obs_websocket/obs_websocket.dart';

part 'sound_event.dart';
part 'sound_state.dart';

class SoundBloc extends Bloc<SoundEvent, SoundState> {
  SoundBloc({required Future<OBSManagerModel> manager}) : _manager = manager, super(SoundInitial()) {
    on<SoundInitialized>(_onInitConfiguration);
    on<SoundConfigured>(_onDetectedSoundConfiguration);
    on<SoundToggled>(_onSoundToggled);
  }

  Future<void> _onInitConfiguration(SoundInitialized event, Emitter<SoundState> emit) async {
    if (kDebugMode) {
      print('SoundInitialized - ${event.isSoundMuted}');
    }
    emit(SoundIsLoading());
    final OBSManagerModel manager = await _manager;
    final ObsWebSocket obsWebSocket = manager.obsWebSocket;
    final String inputName = await SoundRepository.detectSoundConfiguration(obsWebSocket: obsWebSocket);
    final Either<String, bool?> response = await ServerService.baseRequest<bool?>(
      getConcrete: () => SoundRepository.getStatusSound(inputName: inputName, obsWebSocket: obsWebSocket),
    );
    switch (response) {
      case Left():
        emit(SoundHasError(message: response.value));
      case Right():
        if (kDebugMode) {
          print('Sound Bloc - SoundInitialized - ${response.value}');
        }
        emit(
          SoundHasNewStatus(
            isSoundActive: response.value ?? false,
            correctSoundName: inputName,
          ),
        );
    }
  }

  Future<void> _onDetectedSoundConfiguration(SoundConfigured event, Emitter<SoundState> emit) async {
    if (kDebugMode) {
      print('SoundConfigured - HELLOO');
    }
    emit(SoundIsLoading());
    final OBSManagerModel manager = await _manager;
    final ObsWebSocket obsWebSocket = manager.obsWebSocket;
    final String inputName = await SoundRepository.detectSoundConfiguration(obsWebSocket: obsWebSocket);
    final Either<String, bool?> response = await ServerService.baseRequest<bool?>(
      getConcrete: () async {
        return SoundRepository.getStatusSound(inputName: inputName, obsWebSocket: obsWebSocket);
      },
    );
    switch (response) {
      case Left():
        emit(SoundHasError(message: response.value));
      case Right():
        if (kDebugMode) {
          print('Sound Bloc - ${response.value}');
        }
        emit(
          SoundHasNewStatus(
            isSoundActive: response.value ?? false,
            correctSoundName: inputName,
          ),
        );
    }
  }

  Future<void> _onSoundToggled(SoundToggled event, Emitter<SoundState> emit) async {
    if (kDebugMode) {
      print('SoundToggled - ${event.soundName}');
    }
    emit(SoundIsLoading());
    final OBSManagerModel manager = await _manager;
    final ObsWebSocket obsWebSocket = manager.obsWebSocket;
    final Either<String, bool> response = await ServerService.baseRequest<bool>(
      getConcrete: () => SoundRepository.toogleMuteSound(
        inputName: event.soundName,
        obsWebSocket: obsWebSocket,
      ),
    );
    switch (response) {
      case Left():
        emit(SoundHasError(message: response.value));
      case Right():
        if (kDebugMode) {
          print('Sound Bloc - ${response.value}');
        }
        emit(
          SoundHasNewStatus(
            isSoundActive: response.value,
            correctSoundName: event.soundName,
          ),
        );
    }
  }

  final Future<OBSManagerModel> _manager;
}
