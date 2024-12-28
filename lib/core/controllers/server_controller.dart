import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/cache_controller.dart';
import 'package:obs_for_sama/core/controllers/scenes_controller.dart';
import 'package:obs_for_sama/core/controllers/sound_controller.dart';
import 'package:obs_for_sama/core/controllers/sources_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/core/failures/failures.dart';
import 'package:obs_websocket/obs_websocket.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// # [ServerController]
/// Controller to manage [ObsWebSocket] library and [FormState].
class ServerController extends GetxController {
  late ObsWebSocket? obsWebSocket;
  final GlobalKey<FormState> settingsFormKey = GlobalKey<FormState>();
  final TextEditingController textEditingControllerIp = TextEditingController();
  final TextEditingController textEditingControllerPort = TextEditingController();
  final TextEditingController textEditingControllerPassword = TextEditingController();
  final RxString obsStatusMessage = 'Loading...'.obs;
  final RxBool isOBSSynchronized = false.obs;
  final Rx<StatusStream> isStreamStarted = StatusStream.stopped.obs;
  late final Rx<Failure> failure = Failure().obs;

  @override
  void onClose() {
    textEditingControllerIp.dispose();
    textEditingControllerPort.dispose();
    textEditingControllerPassword.dispose();
    super.onClose();
  }

  Future<void> submit({
    required ValueChanged<Failure> onFailure,
    required ValueChanged<bool> onSuccess,
  }) async {
    // print('Je lance le submit');
    resetError();

    if (settingsFormKey.currentState!.validate()) {
      final cacheController = Get.put(CacheController());
      final SharedPreferencesWithCache cache = await cacheController.prefsWithCache;
      await cache.setString(SettingsEnum.ip.label, textEditingControllerIp.text);
      await cache.setString(SettingsEnum.port.label, textEditingControllerPort.text);
      await cache.setString(SettingsEnum.password.label, textEditingControllerPassword.text);

      // print('Le mot de passe est = ${textEditingControllerPassword.text}');
      await connectToOBS();
      if (failure.value is! NoFailure) {
        // print('On lance la failure : ${failure.value}');
        onFailure(failure.value);
        // print('je reset le failure');
        resetError();
        // await cache.remove(SettingsEnum.ip.label);
        // await cache.remove(SettingsEnum.port.label);
        // await cache.remove(SettingsEnum.password.label);
        // await cache.clear();
        // print('je clear le cache normalement');
      } else {
        // print('On lance pas la failure');
        // Get.back<void>();
        onSuccess(true);
      }
    }
  }

  Future<void> submitQrCode({ValueChanged<Failure>? onFailure, ValueChanged<bool>? onSuccess}) async {
    // print('Je lance le submit');

    final cacheController = Get.put(CacheController());
    final SharedPreferencesWithCache cache = await cacheController.prefsWithCache;
    await cache.setString(SettingsEnum.ip.label, textEditingControllerIp.text);
    await cache.setString(SettingsEnum.port.label, textEditingControllerPort.text);
    await cache.setString(SettingsEnum.password.label, textEditingControllerPassword.text);

    // print('Le mot de passe est = ${textEditingControllerPassword.text}');
    await connectToOBS();
    // print('NoFailure? ${failure.value is! NoFailure}. ${failure.value}');
    if (failure.value is! NoFailure) {
      // print('On lance la failure : ${failure.value}');
      onFailure!(failure.value);
      // print('je reset le failure');
    } else {
      // print('On lance pas la failure');
      onSuccess!(true);
    }
  }

  String showStatusMessage({required String message}) => obsStatusMessage.value = message;
  bool isOBSConnected({required bool isConnected}) => isOBSSynchronized.value = isConnected;
  StatusStream isStreamOnline({required StatusStream status}) => isStreamStarted.value = status;

  Future<ObsWebSocket> init() async {
    return ObsWebSocket.connect(
      'ws://${textEditingControllerIp.text}:${textEditingControllerPort.text}',
      password: textEditingControllerPassword.text,
      fallbackEventHandler: fallBackEvent,
    );
  }

  Future<void> fallBackEvent(Event event) async {
    final SoundController soundController = Get.put(SoundController());
    final ScenesController scenesController = Get.put(ScenesController());
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
    resetError();
    try {
      // print('Je teste la connexion.');
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
    } catch (e) {
      // print('Pas bon.');
      // print(e);
      _manageError(error: e.toString());
      showStatusMessage(message: 'OBS Disconnected...');
      isOBSConnected(isConnected: false);
    }
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
    } catch (e) {
      showStatusMessage(message: 'Erreur lors du démarrage du streaming : $e');
    }
  }

  Future<void> stopStreaming() async {
    try {
      await obsWebSocket?.stream.stop();
    } catch (e) {
      showStatusMessage(message: 'Erreur lors de l‘arrêt du streaming : $e');
    }
  }

  Future<void> reload() async {
    final SoundController soundController = Get.put(SoundController());
    final ScenesController scenesController = Get.put(ScenesController());
    final SourcesController sourcesController = Get.put(SourcesController());

    await showStreamStatus();
    await soundController.getStatusSound();
    await scenesController.getListScenes();
    await sourcesController.getListSourcesByCurrentScene();
  }

  Future<void> listenAllStatesFromOBS() async {
    // print('On listen les states de OBS pour les scenes.');
    final serverController = Get.put(ServerController());
    await serverController.obsWebSocket?.listen(EventSubscription.all.code);
    // await serverController.obsWebSocket?.listen(EventSubscription.inputs.code);
    // await serverController.obsWebSocket?.listen(EventSubscription.scenes.code);
  }

  Future<void> _getLocalDataForSettings() async {
    final cacheController = Get.put(CacheController());
    final SharedPreferencesWithCache cache = await cacheController.prefsWithCache;
    final String? localIp = cache.getString(ip);
    final String? localPort = cache.getString(port);
    final String? localPassword = cache.getString(password);

    if (localIp != null && localPort != null && localPassword != null) {
      // print('Détection des données locales.');
      textEditingControllerIp.text = localIp;
      textEditingControllerPort.text = localPort;
      textEditingControllerPassword.text = localPassword;
    } else {
      // print('Les données locales n‘ont pas été trouvés');
      showStatusMessage(message: 'OBS Disconnected...');
      isOBSConnected(isConnected: false);
    }
  }

  void _manageError({required String error}) {
    // print(error);
    failure.value = NoFailure();
    if (error.contains('SocketException') && error.contains('Failed host lookup')) {
      failure.value = HostFailure();
    }
    if (error.contains('TimeoutException')) {
      failure.value = OBSConnectionFailure();
    }
    if (error.contains('SocketException: Connection refused')) {
      failure.value = PortFailure();
    }
    if (error.contains('Exception: Authentication error with identified response')) {
      failure.value = PasswordFailure();
    }
  }

  void showErrorSnackBar({required Failure failureInfo}) {
    if (failureInfo is! NoFailure) {
      Icon icon = const Icon(Icons.add_alert);
      String message = '';
      if (failureInfo is HostFailure) {
        icon = const Icon(Icons.leak_remove, size: 50);
        message = 'Error IP';
      }
      if (failureInfo is PortFailure) {
        icon = const Icon(Icons.developer_board_off, size: 50);
        message = 'Error Port';
      }
      if (failureInfo is PasswordFailure) {
        icon = const Icon(Icons.key_off, size: 50);
        message = 'Error Password';
      }
      if (failureInfo is OBSConnectionFailure) {
        icon = const Icon(Icons.leak_remove, size: 50);
        message = 'Connection OBS Error';
      }
      Get.snackbar(
        message,
        '',
        messageText: icon, //key_off, key_on, leak_remove, leak_add develo
        backgroundColor: Colors.orangeAccent,
        duration: const Duration(seconds: 4),
      );
    }
  }

  void resetError() {
    failure.value = NoFailure();
  }
}
