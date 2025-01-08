import 'package:flutter/material.dart';
import 'package:obs_for_sama/mvvm/data_layer/service/auth_service.dart';

class AuthRepository {
  const AuthRepository({required this.authService});
  final AuthService authService;

  Future<void> save() async {
    await authService.save();
  }

  GlobalKey<FormState> formKey() {
    return authService.settingsFormKey;
  }

  TextEditingController getTextFieldIp() {
    return authService.textEditingControllerIp;
  }

  TextEditingController getTextFieldPort() {
    return authService.textEditingControllerPort;
  }

  TextEditingController getTextFieldPassword() {
    return authService.textEditingControllerPassword;
  }
}
