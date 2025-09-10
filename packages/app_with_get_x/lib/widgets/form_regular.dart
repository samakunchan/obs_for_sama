import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../core/controllers/obs/auth_obs_form_controller.dart';
import '../core/controllers/obs/error_controller.dart';
import '../core/index.dart';

class FormRegular extends StatelessWidget {
  const FormRegular({super.key});

  @override
  Widget build(BuildContext context) {
    final ErrorController errorController = Get.find();
    final AuthObsFormController formController = Get.find();

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
                key: formController.settingsFormKey,
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
                          controller: formController.textEditingControllerIp,
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
                          controller: formController.textEditingControllerPort,
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
                          controller: formController.textEditingControllerPassword,
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
                              onPressed: formController.clearTextFields,
                              child: FaIcon(
                                FontAwesomeIcons.eraser,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                          Obx(() {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: formController.isSubmitting.value
                                  ? CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary)
                                  : TextButton(
                                      onPressed: () {
                                        if (formController.settingsFormKey.currentState!.validate()) {
                                          formController.isSubmitting.value = true;

                                          formController.submit(
                                            onSuccess: (bool value) {
                                              Get.back<void>();
                                              formController.isSubmitting.value = false;
                                            },
                                            onFailure: (Failure failure) {
                                              errorController.showErrorSnackBar(failureInfo: failure);
                                              formController.isSubmitting.value = false;
                                            },
                                          );
                                        }
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.floppyDisk,
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                    ),
                            );
                          }),
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
}
