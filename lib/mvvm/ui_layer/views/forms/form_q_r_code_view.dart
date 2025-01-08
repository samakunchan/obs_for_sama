import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/constantes.dart';
import 'package:obs_for_sama/core/failures/failures.dart';
import 'package:obs_for_sama/mvvm/ui_layer/view_models/o_b_s_server_view_model.dart';
import 'package:obs_for_sama/widgets/r_s_i_outlined_body.dart';

class FormQRCodeView extends GetView<OBSServerViewModel> {
  const FormQRCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    // final AuthObsFormController formController = Get.find();
    controller.isLookingForQRCode.value = true;
    controller.isCorrectQRCode?.value = true;

    return RSIOutlinedBody(
      edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
      color: controller.isCorrectQRCode?.value != null && controller.isCorrectQRCode?.value == false ? Colors.red : kButtonColor,
      child: controller.isLookingForQRCode.value
          ? Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  onDetect: _handleBarcode,
                ),
                if (controller.isCorrectQRCode?.value != null && controller.isCorrectQRCode?.value == false)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      widthFactor: 300,
                      alignment: Alignment.topRight,
                      child: Chip(
                        side: const BorderSide(color: Colors.red),
                        color: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.hovered) ||
                                states.contains(WidgetState.pressed) ||
                                states.contains(WidgetState.focused)) {
                              return kButtonColor;
                            }
                            return Colors.red;
                          },
                        ),
                        label: const Text('Wrong format QR Code'),
                      ),
                    ),
                  ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Got it', style: ktitle1),
                AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: controller.isAutoConnectToOBS?.value != null
                      ? Column(
                          children: [
                            const CircularProgressIndicator(
                              color: kTextColorWhite,
                            ),
                            Text(
                              'Connectting to OBS...',
                              style: ktitle2,
                            ),
                          ],
                        )
                      : const SizedBox(),
                ),
              ],
            ),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (!controller.isClosed) {
      print('CODE BARRE : ${barcodes.barcodes.firstOrNull!.displayValue}');
      final String result = barcodes.barcodes.firstOrNull!.displayValue!;
      if (result.contains('obsws')) {
        final RegExp regExpIp = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b');
        final RegExp regExpPort = RegExp(r':(\d+)');
        final RegExp regExpPW = RegExp(r'/([^/]+)$');

        final String ip = regExpIp.stringMatch(result) ?? '';
        final String port = regExpPort.firstMatch(result)?.group(1) ?? '';
        final String token = regExpPW.firstMatch(result)?.group(1) ?? '';

        controller.isLookingForQRCode.value = false;
        controller.isCorrectQRCode?.value = true;
        controller.isAutoConnectToOBS?.value = true;

        controller.userGetTextFieldUseCase.getTextFieldIp().value = TextEditingValue(text: ip);
        controller.userGetTextFieldUseCase.getTextFieldPort().value = TextEditingValue(text: port);
        controller.userGetTextFieldUseCase.getTextFieldPassword().value = TextEditingValue(text: token);

        controller.submit(
          onSuccess: (_) {
            Get.back<void>();
            controller.isCorrectQRCode?.value = false;
            controller.isOBSConnected(isConnected: true);
          },
          onFailure: (Failure failure) {
            controller.isAutoConnectToOBS?.value = false;
            controller.isOBSConnected(isConnected: false);
          },
        );
      } else {
        controller.isLookingForQRCode.value = true;
        controller.isCorrectQRCode?.value = false;
      }
    }
  }
}
