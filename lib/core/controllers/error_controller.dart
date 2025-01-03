import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/failures/failures.dart';

class ErrorController extends GetxController {
  late final Rx<Failure> failure = Failure().obs;

  void manageError({required String error}) {
    print(error);
    failure.value = NoFailure();
    if (error.contains('SocketException') && error.contains('Failed host lookup')) {
      failure.value = HostFailure();
    }
    if (error.contains('TimeoutException')) {
      failure.value = OBSConnectionFailure();
    }
    if (error.contains('Connection refused')) {
      failure.value = OBSConnectionFailure();
    }
    if (error.contains('Exception: Authentication error with identified response')) {
      failure.value = PasswordFailure();
    }
  }

  void showErrorSnackBar({required Failure failureInfo}) {
    print(failureInfo);
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
        message = 'Error connection server OBS';
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
