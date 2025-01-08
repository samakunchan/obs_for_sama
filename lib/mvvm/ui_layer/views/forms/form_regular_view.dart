import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/constantes.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/core/failures/failures.dart';
import 'package:obs_for_sama/mvvm/ui_layer/view_models/o_b_s_server_view_model.dart';
import 'package:obs_for_sama/widgets/r_s_i_outlined_body.dart';

class FormRegularView extends GetView<OBSServerViewModel> {
  const FormRegularView({super.key});

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
                key: controller.userGetTextFieldUseCase.formKey(),
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
                          obscureText: true,
                          controller: controller.userGetTextFieldUseCase.getTextFieldIp(),
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
                          obscureText: true,
                          controller: controller.userGetTextFieldUseCase.getTextFieldPort(),
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
                          obscureText: true,
                          controller: controller.userGetTextFieldUseCase.getTextFieldPassword(),
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
                              onPressed: controller.clearTextFields,
                              child: FaIcon(
                                FontAwesomeIcons.eraser,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                          Obx(() {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: controller.isSubmitting.value
                                  ? CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary)
                                  : TextButton(
                                      onPressed: () {
                                        if (controller.userGetTextFieldUseCase.formKey().currentState!.validate()) {
                                          controller.isSubmitting.value = true;

                                          controller.submit(
                                            onSuccess: (bool value) {
                                              controller.isSubmitting.value = false;
                                              controller.isOBSConnected(isConnected: true);
                                              Get.back<void>();
                                            },
                                            onFailure: (Failure failure) {
                                              controller.isSubmitting.value = false;
                                              controller.isOBSConnected(isConnected: false);
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
