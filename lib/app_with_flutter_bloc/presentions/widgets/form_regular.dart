import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/bloc/cache_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/cache/dto/cache_d_t_o.dart';
import 'package:obs_for_sama/core/index.dart';

class FormRegular extends StatefulWidget {
  const FormRegular({super.key});

  @override
  State<FormRegular> createState() => _FormRegularState();
}

class _FormRegularState extends State<FormRegular> {
  bool isSubmitting = false;
  final GlobalKey<FormState> settingsFormKey = GlobalKey<FormState>();
  final TextEditingController textEditingControllerIp = TextEditingController();
  final TextEditingController textEditingControllerPassword = TextEditingController();
  final TextEditingController textEditingControllerPort = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: RSIOutlinedBody(
        edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// FORM
              Form(
                key: settingsFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// IP TEXTFIELD
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextFormField(
                          cursorColor: kTextColorWhite,
                          obscureText: !Platform.isWindows,
                          controller: textEditingControllerIp,
                          // placeholder: '192.XXX.XXX.XXX',
                          decoration: InputDecoration(
                            labelText: SettingsEnum.ip.label,
                            prefixIcon: const Icon(Icons.leak_add),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please add obs websocket I.P.';
                            }
                            return null;
                          },
                        ),
                      ),

                      /// PORT TEXTFIELD
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextFormField(
                          cursorColor: kTextColorWhite,
                          obscureText: !Platform.isWindows,
                          controller: textEditingControllerPort,
                          // placeholder: '1234',
                          decoration: InputDecoration(
                            labelText: SettingsEnum.port.label,
                            prefixIcon: const Icon(Icons.developer_board),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please add obs websocket port.';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),

                      /// PASSWORD TEXTFIELD
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextFormField(
                          cursorColor: kTextColorWhite,
                          obscureText: !Platform.isWindows,
                          controller: textEditingControllerPassword,
                          // placeholder: 'OBS Websocket Password',
                          decoration: InputDecoration(
                            labelText: SettingsEnum.password.label,
                            prefixIcon: const Icon(Icons.key),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please add obs websocket password.';
                            }
                            return null;
                          },
                        ),
                      ),

                      /// ACTIONS BUTTONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextButton(
                              onPressed: clearTextFields,
                              child: FaIcon(
                                FontAwesomeIcons.eraser,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: isSubmitting
                                ? CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary)
                                : TextButton(
                                    onPressed: () {
                                      if (settingsFormKey.currentState!.validate()) {
                                        setState(() {
                                          isSubmitting = true;
                                        });
                                        final CacheDTO cacheDTO = CacheDTO(
                                          localIp: textEditingControllerIp.text,
                                          localPassword: textEditingControllerPassword.text,
                                          localPort: textEditingControllerPort.text,
                                        );
                                        context.read<CacheBloc>().add(CacheWritten(cacheDTO: cacheDTO));
                                      }
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.floppyDisk,
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> clearTextFields() async {
    textEditingControllerPassword.clear();
    textEditingControllerIp.clear();
    textEditingControllerPort.clear();
  }

  Future<void> submit({
    required ValueChanged<Failure> onFailure,
    required ValueChanged<bool> onSuccess,
  }) async {
    // print('Je lance le submit');
    // final ErrorController errorController = Get.find()..resetError();
    // final CacheController cacheController = Get.find();
    // final ServerController controller = Get.find();
    // final SharedPreferencesWithCache cache = await cacheController.prefsWithCache;
    // await cache.setString(SettingsEnum.ip.label, textEditingControllerIp.text);
    // await cache.setString(SettingsEnum.port.label, textEditingControllerPort.text);
    // await cache.setString(SettingsEnum.password.label, textEditingControllerPassword.text);

    // await controller.connectToOBS();
    // if (errorController.failure.value is! NoFailure) {
    //   onFailure(errorController.failure.value);
    //   errorController.resetError();
    // } else {
    //   // print('On lance pas la failure');
    //   onSuccess(true);
    // }
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
}
