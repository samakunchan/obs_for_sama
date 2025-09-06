import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/messages/enums/messages_enum.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/o_b_s_status/bloc/o_b_s_status_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/exceptions/server_exception.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/singleton/o_b_s_singleton.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/sound/bloc/sound_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/sound/repositories/sound_repository.dart';
import 'package:obs_for_sama/core/index.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ServerRepository {
  Future<StatusStream> connectToOBS() async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      if (kDebugMode) {
        print('ETTAT $obsWebSocket');
      }
      if (obsWebSocket == null) {
        throw Exception(AppMessagesEnum.cacheEmpty.key);
      }

      if (kDebugMode) {
        print('ServerRepository - Lors de la connexion $obsWebSocket');
      }
      await listenAllStatesFromOBS();

      /// Detection si OBS est actif
      final ProfileListResponse defaultProfile = await obsWebSocket.config.getProfileList();
      if (defaultProfile.currentProfileName.isNotEmpty) {
        await reload();
        return StatusStream.started;
      }
      throw Exception(StatusStream.stopped.name);
    } on SocketException catch (e) {
      throw ServerException(e.message);
    } on Exception catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> logoutToOBS() async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    await obsWebSocket?.close();
  }

  Future<StatusStream> showStreamStatus() async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    final StreamStatusResponse? response = await obsWebSocket?.stream.status;
    if (response == null) return StatusStream.stopped;
    return response.outputActive ? StatusStream.started : StatusStream.stopped;
  }

  // Future<StatusStream> _showStreamStatus(StreamStatusResponse response) async {
  //   final StatusStream statusStream = response.outputActive ? StatusStream.started : StatusStream.stopped;
  //   // isStreamOnline(status: statusStream);
  //   return statusStream;
  // }

  Future<StatusStream> reload() async {
    final String inputName = await SoundRepository.detectSoundConfiguration();
    await SoundRepository.getStatusSound(inputName: inputName);
    return showStreamStatus();
  }

  Future<void> listenAllStatesFromOBS() async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    try {
      await obsWebSocket?.subscribe(EventSubscription.all);
    } on Exception catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> fallBackEvent(Event event, BuildContext context) async {
    if (kDebugMode) {
      print('On est dans le fallback');
    }
    if (event.eventType == 'CurrentProgramSceneChanged') {
      // await _obs?.scenes.setCurrentProgramScene(event.eventData!['sceneName'].toString());
      // final String currentScene = await _obs?.scenes.getCurrentProgramScene() ?? 'no scene';
      // scenesController.currentSceneName.value = currentScene;

      // final SourcesController sourcesController = Get.put(SourcesController());
      // await sourcesController.getListSourcesByCurrentScene();
    }

    if (event.eventType == 'InputMuteStateChanged') {
      context.read<SoundBloc>().add(SoundInitialized(isSoundMuted: event.eventData!['inputMuted'] as bool));
    }

    if (event.eventType == 'StreamStateChanged') {
      StatusStream statusStream = StatusStream.stopped;
      if (event.eventData!['outputState'].toString() == 'OBS_WEBSOCKET_OUTPUT_STARTING') {
        statusStream = StatusStream.isStarting;
      }
      if (event.eventData!['outputState'].toString() == 'OBS_WEBSOCKET_OUTPUT_STARTED') {
        statusStream = StatusStream.started;
        await WakelockPlus.enable();
      }
      if (event.eventData!['outputState'].toString() == 'OBS_WEBSOCKET_OUTPUT_STOPPING') {
        statusStream = StatusStream.isStopping;
      }
      if (event.eventData!['outputState'].toString() == 'OBS_WEBSOCKET_OUTPUT_STOPPED') {
        statusStream = StatusStream.stopped;
      }
      if (!context.mounted) return;
      context.read<OBSStatusBloc>().add(OBSStatusStreamChanged(statusStream: statusStream));
    }
  }
}
