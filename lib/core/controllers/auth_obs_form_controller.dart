import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/cache_controller.dart';
import 'package:obs_for_sama/core/controllers/error_controller.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/core/failures/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthObsFormController extends GetxController {
  final GlobalKey<FormState> settingsFormKey = GlobalKey<FormState>();
  final TextEditingController textEditingControllerIp = TextEditingController();
  final TextEditingController textEditingControllerPort = TextEditingController();
  final TextEditingController textEditingControllerPassword = TextEditingController();
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

    if (settingsFormKey.currentState!.validate()) {
      final CacheController cacheController = Get.find();
      final ServerController controller = Get.find();
      final SharedPreferencesWithCache cache = await cacheController.prefsWithCache;
      await cache.setString(SettingsEnum.ip.label, textEditingControllerIp.text);
      await cache.setString(SettingsEnum.port.label, textEditingControllerPort.text);
      await cache.setString(SettingsEnum.password.label, textEditingControllerPassword.text);

      // print('Le mot de passe est = ${textEditingControllerPassword.text}');
      await controller.connectToOBS();
      if (errorController.failure.value is! NoFailure) {
        // print('On lance la failure : ${failure.value}');
        onFailure(errorController.failure.value);
        // print('je reset le failure');
        errorController.resetError();
      } else {
        // print('On lance pas la failure');
        onSuccess(true);
      }
    }
  }

  Future<void> submitQrCode({ValueChanged<Failure>? onFailure, ValueChanged<bool>? onSuccess}) async {
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
      onFailure!(errorController.failure.value);
      errorController.resetError();
    } else {
      // print('On lance pas la failure');
      onSuccess!(true);
    }
  }
}
