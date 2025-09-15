import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../../core/index.dart';
import '../../o_b_s_scenes/bloc/current_scene_bloc.dart';
import '../../o_b_s_sources/bloc/o_b_s_sources_bloc.dart';
import '../../o_b_s_status/bloc/o_b_s_status_bloc.dart';
import '../../o_b_s_status/repositories/o_b_s_status_repository.dart';
import '../../sound/bloc/sound_bloc.dart';
import '../../sound/repositories/sound_repository.dart';
import '../singleton/o_b_s_singleton.dart';

/// # [ServerRepository]
/// Controller to manage [ObsWebSocket] library and [FormState].
class ServerRepository {
  Future<StatusStream> connectToOBS() async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    try {
      if (kDebugMode) {
        print('ETTAT $obsWebSocket');
      }
      if (obsWebSocket == null) {
        throw Exception(AppMessagesEnum.cacheEmpty.key);
      }

      if (kDebugMode) {
        print('ServerRepository - Lors de la connexion $obsWebSocket');
      }
      await listenAllStatesFromOBS(obsWebSocket);

      /// Detection si OBS est actif
      final RequestResponse? response = await obsWebSocket.sendRequest(Request('GetProfileList'));

      if (response != null) {
        final ProfileListResponse defaultProfile = ProfileListResponse.fromJson(response.responseData!);
        if (defaultProfile.currentProfileName.isNotEmpty) {
          await reload();
          return StatusStream.started;
        }
      }
      throw Exception(AppMessagesEnum.serverError.key);
    } on Exception catch (e) {
      throw OBSServerException(e.toString());
    }
  }

  /// Not use actually
  /// Use to disconnect from OBS session.
  Future<void> logoutToOBS() async {
    try {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      await obsWebSocket?.close();
      OBSSingleton().clearObsInstance();
    } on Exception {
      throw OBSServerException('SERVER_CANNOT_DISCONNECTED');
    }
  }

  Future<StatusStream> reload() async {
    final String inputName = await SoundRepository.detectSoundConfiguration();
    await SoundRepository.getStatusSound(inputName: inputName);
    return OBSStatusRepository.showStreamStatus();
  }

  /// Subscription to listen all states.
  Future<void> listenAllStatesFromOBS(ObsWebSocket? obsWebSocket) async {
    try {
      print('La gueule de l‘instance : $obsWebSocket');
      await obsWebSocket?.subscribe(EventSubscription.all);
    } on Exception catch (e) {
      throw OBSServerException(e.toString());
    }
  }

  /// Method to listen all state from OBS Software and emit event to update the mobile app.
  Future<void> fallBackEvent(Event event, BuildContext context) async {
    if (kDebugMode) {
      print('On est dans le fallback');
    }
    if (event.eventType == 'CurrentProgramSceneChanged') {
      final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
      await obsWebSocket?.scenes.setCurrentProgramScene(event.eventData!['sceneName'].toString());
      final String currentScene = await obsWebSocket?.scenes.getCurrentProgramScene() ?? 'no scene';
      if (!context.mounted) return;
      context.read<CurrentSceneBloc>().add(CurrentSceneChanged(sceneName: currentScene));
      context.read<OBSSourcesBloc>().add(OBSSourcesFetched(sceneName: currentScene));
    }

    if (event.eventType == 'InputMuteStateChanged') {
      if (!context.mounted) return;
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
