import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/obs/cache_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/error_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/server_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/core/failures/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthObsFormController extends GetxController {
  final GlobalKey<FormState> settingsFormKey = GlobalKey<FormState>();
  final TextEditingController textEditingControllerIp = TextEditingController();
  final TextEditingController textEditingControllerPort = TextEditingController();
  final TextEditingController textEditingControllerPassword = TextEditingController();

  late RxBool isSubmitting = false.obs;
  late RxBool isLookingForQRCode = true.obs;
  RxBool? isCorrectQRCode;
  RxBool? isAutoConnectToOBS;

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
    final ErrorController errorController = Get.find()..resetError();
    final CacheController cacheController = Get.find();
    final ServerController controller = Get.find();
    final SharedPreferencesWithCache cache = await cacheController.prefsWithCache;
    await cache.setString(SettingsEnum.ip.label, textEditingControllerIp.text);
    await cache.setString(SettingsEnum.port.label, textEditingControllerPort.text);
    await cache.setString(SettingsEnum.password.label, textEditingControllerPassword.text);

    await controller.connectToOBS();
    if (errorController.failure.value is! NoFailure) {
      onFailure(errorController.failure.value);
      errorController.resetError();
    } else {
      // print('On lance pas la failure');
      onSuccess(true);
    }
  }

  Future<void> clearTextFields() async {
    isSubmitting.value = false;
    textEditingControllerPassword.clear();
    textEditingControllerIp.clear();
    textEditingControllerPort.clear();
  }
}
