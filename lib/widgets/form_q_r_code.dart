import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/constantes.dart';
import 'package:obs_for_sama/core/controllers/obs/auth_obs_form_controller.dart';
import 'package:obs_for_sama/core/controllers/obs/error_controller.dart';
import 'package:obs_for_sama/core/failures/failures.dart';
import 'package:obs_for_sama/widgets/r_s_i_outlined_body.dart';

class FormQRCode extends StatefulWidget {
  const FormQRCode({super.key});

  @override
  State<FormQRCode> createState() => _FormQRCodeState();
}

class _FormQRCodeState extends State<FormQRCode> {
  @override
  Widget build(BuildContext context) {
    final AuthObsFormController formController = Get.find();
    formController.isLookingForQRCode.value = true;
    formController.isCorrectQRCode?.value = true;

    return RSIOutlinedBody(
      edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
      color: formController.isCorrectQRCode?.value != null && formController.isCorrectQRCode?.value == false ? Colors.red : kButtonColor,
      child: formController.isLookingForQRCode.value
          ? Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  onDetect: _handleBarcode,
                ),
                if (formController.isCorrectQRCode?.value != null && formController.isCorrectQRCode?.value == false)
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
                  child: formController.isAutoConnectToOBS?.value != null
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
    final AuthObsFormController formController = Get.find();
    final ErrorController errorController = Get.find();
    if (mounted) {
      // print('CODE BARRE : ${barcodes.barcodes.firstOrNull!.displayValue}');
      final String result = barcodes.barcodes.firstOrNull!.displayValue!;
      if (result.contains('obsws')) {
        final RegExp regExpIp = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b');
        final RegExp regExpPort = RegExp(r':(\d+)');
        final RegExp regExpPW = RegExp(r'/([^/]+)$');

        final String ip = regExpIp.stringMatch(result) ?? '';
        final String port = regExpPort.firstMatch(result)?.group(1) ?? '';
        final String token = regExpPW.firstMatch(result)?.group(1) ?? '';

        formController.isLookingForQRCode.value = false;
        formController.isCorrectQRCode?.value = true;
        formController.isAutoConnectToOBS?.value = true;

        formController.textEditingControllerIp.value = TextEditingValue(text: ip);
        formController.textEditingControllerPort.value = TextEditingValue(text: port);
        formController.textEditingControllerPassword.value = TextEditingValue(text: token);

        formController.submit(
          onSuccess: (_) {
            Get.back<void>();
            formController.isCorrectQRCode?.value = false;
          },
          onFailure: (Failure failure) {
            errorController.showErrorSnackBar(failureInfo: failure);

            formController.isAutoConnectToOBS?.value = false;
          },
        );
      } else {
        formController.isLookingForQRCode.value = true;
        formController.isCorrectQRCode?.value = false;
      }
    }
  }
}
