import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/obs/auth_obs_form_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/cache_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/error_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/scenes_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/sound_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/sources_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// # [ServerController]
/// Controller to manage [ObsWebSocket] library and [FormState].
class ServerController extends GetxController {
  late ObsWebSocket? obsWebSocket;
  final RxString obsStatusMessage = 'Loading...'.obs;
  final RxBool isOBSSynchronized = false.obs;
  final Rx<StatusStream> isStreamStarted = StatusStream.stopped.obs;

  String showStatusMessage({required String message}) => obsStatusMessage.value = message;
  bool isOBSConnected({required bool isConnected}) => isOBSSynchronized.value = isConnected;
  StatusStream isStreamOnline({required StatusStream status}) => isStreamStarted.value = status;

  Future<ObsWebSocket> init() async {
    final AuthObsFormController formController = Get.find();

    return ObsWebSocket.connect(
      'ws://${formController.textEditingControllerIp.text}:${formController.textEditingControllerPort.text}',
      password: formController.textEditingControllerPassword.text,
      fallbackEventHandler: fallBackEvent,
    );
  }

  Future<void> fallBackEvent(Event event) async {
    final SoundController soundController = Get.find();
    final ScenesController scenesController = Get.find();
    // print('type: ${event.eventType} data: ${event.eventData}');
    if (event.eventType == 'CurrentProgramSceneChanged') {
      await obsWebSocket?.scenes.setCurrentProgramScene(event.eventData!['sceneName'].toString());
      final String currentScene = await obsWebSocket?.scenes.getCurrentProgramScene() ?? 'no scene';
      scenesController.currentSceneName.value = currentScene;

      final SourcesController sourcesController = Get.put(SourcesController());
      await sourcesController.getListSourcesByCurrentScene();
    }

    if (event.eventType == 'InputMuteStateChanged') {
      soundController.isSoundMuted.value = event.eventData!['inputMuted'] as bool;
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
      isStreamOnline(status: statusStream);
    }
  }

  Future<void> connectToOBS() async {
    final ErrorController errorController = Get.find()..resetError();

    try {
      // print('Je teste la connexion.');
      // if (obsWebSocket != null && !obsWebSocket.isBlank!) {
      //   print(obsWebSocket.isBlank);
      // }
      await _getLocalDataForSettings();
      obsWebSocket = await init();

      /// Detection si OBS est actif
      final ProfileListResponse? defaultProfile = await obsWebSocket?.config.getProfileList();
      if (defaultProfile != null && defaultProfile.currentProfileName.isNotEmpty) {
        // print('OBS est actif.');
        await reload();
        isOBSConnected(isConnected: true);
      }
      // print('Terminer');
    } on Exception catch (e) {
      // print('Pas bon.');
      // print(e);
      errorController.manageError(error: e.toString());
      showStatusMessage(message: 'OBS Disconnected...');
      isOBSConnected(isConnected: false);
    }
  }

  Future<void> logoutToOBS() async {
    await obsWebSocket?.close();
  }

  Future<void> showStreamStatus() async {
    await obsWebSocket?.stream.status.then(_showStreamStatus);
  }

  Future<void> _showStreamStatus(StreamStatusResponse response) async {
    final StatusStream statusStream = response.outputActive ? StatusStream.started : StatusStream.stopped;
    isStreamOnline(status: statusStream);
  }

  Future<void> startStreaming() async {
    try {
      await obsWebSocket?.stream.start();
      await WakelockPlus.enable();
    } on Exception catch (e) {
      showStatusMessage(message: 'Erreur lors du démarrage du streaming : $e');
    }
  }

  Future<void> stopStreaming() async {
    try {
      await obsWebSocket?.stream.stop();
      await WakelockPlus.disable();
    } on Exception catch (e) {
      showStatusMessage(message: 'Erreur lors de l‘arrêt du streaming : $e');
    }
  }

  Future<void> reload() async {
    final SoundController soundController = Get.find();
    final ScenesController scenesController = Get.find();
    final SourcesController sourcesController = Get.find();

    await soundController.detectSoundConfiguration();
    await showStreamStatus();
    await soundController.getStatusSound();
    await scenesController.getListScenes();
    await sourcesController.getListSourcesByCurrentScene();
  }

  Future<void> listenAllStatesFromOBS() async {
    // print('On listen les states de OBS pour les scenes.');
    try {
      await obsWebSocket?.subscribe(EventSubscription.all);
    } on Exception catch (_) {
      // print(e);
      showStatusMessage(message: 'OBS Disconnected...');
      isOBSConnected(isConnected: false);
    }
  }

  Future<void> _getLocalDataForSettings() async {
    final CacheController cacheController = Get.find();
    final AuthObsFormController formController = Get.find();
    final SharedPreferencesWithCache cache = await cacheController.prefsWithCache;
    final String? localIp = cache.getString(ip);
    final String? localPort = cache.getString(port);
    final String? localPassword = cache.getString(password);

    if (localIp != null && localPort != null && localPassword != null) {
      // print('Détection des données locales.');
      formController.textEditingControllerIp.text = localIp;
      formController.textEditingControllerPort.text = localPort;
      formController.textEditingControllerPassword.text = localPassword;
    } else {
      // print('Les données locales n‘ont pas été trouvés');
      showStatusMessage(message: 'OBS Disconnected...');
      isOBSConnected(isConnected: false);
    }
  }
}
