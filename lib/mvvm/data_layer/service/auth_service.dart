import 'package:flutter/material.dart';

class AuthService {
  final GlobalKey<FormState> settingsFormKey = GlobalKey<FormState>();
  final TextEditingController textEditingControllerIp = TextEditingController();
  final TextEditingController textEditingControllerPort = TextEditingController();
  final TextEditingController textEditingControllerPassword = TextEditingController();

  Future<void> save() async {}

  GlobalKey<FormState> formKey() {
    return settingsFormKey;
  }

  TextEditingController getTextFieldIp() {
    return textEditingControllerIp;
  }

  TextEditingController getTextFieldPort() {
    return textEditingControllerPort;
  }

  TextEditingController getTextFieldPassword() {
    return textEditingControllerPassword;
  }
}
