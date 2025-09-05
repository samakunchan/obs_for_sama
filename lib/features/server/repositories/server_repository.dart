import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:obs_for_sama/core/core_theme_index.dart';
import 'package:obs_for_sama/features/messages/enums/messages_enum.dart';
import 'package:obs_for_sama/features/server/exceptions/server_exception.dart';
import 'package:obs_for_sama/features/server/singleton/o_b_s_singleton.dart';
import 'package:obs_for_sama/features/sound/repositories/sound_repository.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ServerRepository {
  // ServerRepository();
  // final ObsWebSocket? obsWebSocket;
  Future<StatusStream> connectToOBS() async {
    try {
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
      if (!connectivityResult.contains(ConnectivityResult.wifi)) {
        throw SocketException(AppMessagesEnum.wifiError.key);
      }

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

  Future<void> startStreaming() async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    try {
      await obsWebSocket?.stream.start();

      // TODO(Sama): ajouter ça dans le retour de mise en veille
      await WakelockPlus.enable();
    } on Exception catch (e) {
      throw ServerException('Erreur lors du démarrage du streaming : $e');
    }
  }

  Future<void> stopStreaming() async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;
    try {
      await obsWebSocket?.stream.stop();
      await WakelockPlus.disable();
    } on Exception catch (e) {
      throw ServerException('Erreur lors de l‘arrêt du streaming : $e');
    }
  }

  Future<StatusStream> reload() async {
    final ObsWebSocket? obsWebSocket = await OBSSingleton().obs;

    final String inputName = await SoundRepository.detectSoundConfiguration(obsWebSocket: obsWebSocket!);
    await SoundRepository.getStatusSound(inputName: inputName, obsWebSocket: obsWebSocket);
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
}
