import 'package:flutter/material.dart';
import 'package:obs_for_sama/mvvm/data_layer/repository/auth_repository.dart';

class UserGetTextFieldUseCase {
  const UserGetTextFieldUseCase({required this.repository});
  final AuthRepository repository;

  /// Execute the connection to [AuthRepository].
  Future<void> submit() async {
    return repository.save();
  }

  GlobalKey<FormState> formKey() {
    return repository.formKey();
  }

  TextEditingController getTextFieldIp() {
    return repository.getTextFieldIp();
  }

  TextEditingController getTextFieldPort() {
    return repository.getTextFieldPort();
  }

  TextEditingController getTextFieldPassword() {
    return repository.getTextFieldPassword();
  }
}
