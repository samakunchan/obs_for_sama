import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/core/failures/failures.dart';
import 'package:obs_for_sama/mvvm/data_layer/models/auth_form_model.dart';
// import 'package:obs_for_sama/mvvm/data_layer/models/failures_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/models/obs_model.dart';
import 'package:obs_for_sama/mvvm/data_layer/service/cache_service.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/cache_read_use_case.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/cache_write_use_case.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/connect_to_o_b_s_use_case.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/get_exception_use_case.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/get_profile_o_b_s_use_case.dart';
import 'package:obs_for_sama/mvvm/logic_layer/use_cases/user_get_text_field_use_case.dart';

/// # [OBSServerViewModel]
/// Controller to manage [ObsWebSocket].
class OBSServerViewModel extends GetxController {
  OBSServerViewModel({
    required this.connectToOBSUseCase,
    required this.cacheReadUseCase,
    required this.cacheWriteUseCase,
    required this.userGetTextFieldUseCase,
    required this.getExceptionUseCase,
    this.getProfileUseCase,
  });

  final ConnectToOBSUseCase connectToOBSUseCase;
  final GetProfileOBSUseCase? getProfileUseCase;
  final CacheReadUseCase cacheReadUseCase;
  final CacheWriteUseCase cacheWriteUseCase;
  final UserGetTextFieldUseCase userGetTextFieldUseCase;
  final GetExceptionUseCase getExceptionUseCase;
  // late ObsWebSocket? obsWebSocket;
  final RxString obsStatusMessage = 'Loading...'.obs;
  final RxBool isOBSSynchronized = false.obs;
  final Rx<StatusStream> isStreamStarted = StatusStream.stopped.obs;
  late RxBool isSubmitting = false.obs;
  late RxBool isLookingForQRCode = true.obs;
  RxBool? isCorrectQRCode;
  RxBool? isAutoConnectToOBS;

  String showStatusMessage({required String message}) => obsStatusMessage.value = message;
  bool isOBSConnected({required bool isConnected}) => isOBSSynchronized.value = isConnected;
  StatusStream isStreamOnline({required StatusStream status}) => isStreamStarted.value = status;

  @override
  void onInit() {
    connectToOBS();
    listenAllStatesFromOBS();
    _getLocalDataForSettings();
    super.onInit();
  }

  @override
  void onClose() {
    userGetTextFieldUseCase.getTextFieldIp().dispose();
    userGetTextFieldUseCase.getTextFieldPort().dispose();
    userGetTextFieldUseCase.getTextFieldPassword().dispose();
    super.onClose();
  }

  Future<void> connectToOBS() async {
    try {
      // print('Je teste la connexion.');
      // await _getLocalDataForSettings();
      // obsWebSocket =
      final AuthFormModel form = await cacheReadUseCase.read();
      print('OBSServerViewModel - Récupération des données du cache');
      await connectToOBSUseCase.execute(form: form);

      /// Detection si OBS est actif
      final ProfileListResponse? defaultProfile = await getProfileUseCase?.execute(form: form);
      if (defaultProfile != null && defaultProfile.currentProfileName.isNotEmpty) {
        // print('HELLO -- OBS is active.');
        // await reload();
        isOBSConnected(isConnected: true);
      }
      // print('Terminer');
    } catch (e) {
      // print('Pas bon.');
      // print(e);
      showStatusMessage(message: 'OBS Disconnected...');
      isOBSConnected(isConnected: false);
    } finally {}
  }

  Future<void> listenAllStatesFromOBS() async {
    // print('On listen les states de OBS pour les scenes.');
    // try {
    //   await obsWebSocket?.listen(EventSubscription.all.code);
    // } catch (e) {
    //   // print(e);
    //   showStatusMessage(message: 'OBS Disconnected...');
    //   isOBSConnected(isConnected: false);
    // }
  }

  Future<void> submit({
    required ValueChanged<Failure> onFailure,
    required ValueChanged<bool> onSuccess,
  }) async {
    // print('Je lance le submit');

    final AuthFormModel authFormModel = AuthFormModel(
      ip: userGetTextFieldUseCase.getTextFieldIp().text,
      port: userGetTextFieldUseCase.getTextFieldPort().text,
      password: userGetTextFieldUseCase.getTextFieldPassword().text,
    );

    await cacheWriteUseCase.write(form: authFormModel);

    try {
      await connectToOBSUseCase.execute(form: authFormModel);
      // print('La connexion s‘est bien passé.');
    } catch (e) {
      // print('La connexion ne s‘est pas bien passé.');
      await getExceptionUseCase.setFailure(error: e.toString());
    }

    if (getExceptionUseCase.getFailure() is! NoFailure) {
      onFailure(getExceptionUseCase.getFailure());
      getExceptionUseCase
        ..showErrorSnackBar(failureInfo: getExceptionUseCase.getFailure())
        ..resetError();
    } else {
      // print('On lance pas la failure');
      // connectToOBSUseCase.isOBSConnected(isConnected: true);
      onSuccess(true);
    }
  }

  Future<void> clearTextFields() async {
    isSubmitting.value = false;
    userGetTextFieldUseCase.getTextFieldIp().clear();
    userGetTextFieldUseCase.getTextFieldPort().clear();
    userGetTextFieldUseCase.getTextFieldPassword().clear();
  }

  Future<void> _getLocalDataForSettings() async {
    final AuthFormModel form = await cacheReadUseCase.read();

    if (form.ip != noIp && form.port != noPort && form.password != noPassword) {
      // print('Détection des données locales.');
      userGetTextFieldUseCase.getTextFieldIp().text = form.ip;
      userGetTextFieldUseCase.getTextFieldPort().text = form.port;
      userGetTextFieldUseCase.getTextFieldPassword().text = form.password;
    }
  }

  Future<void> reload() async {
    // final SoundController soundController = Get.find();
    // final ScenesController scenesController = Get.find();
    // final SourcesController sourcesController = Get.find();

    // await soundController.detectSoundConfiguration();
    // await showStreamStatus();
    // await soundController.getStatusSound();
    // await scenesController.getListScenes();
    // await sourcesController.getListSourcesByCurrentScene();
  }
}
