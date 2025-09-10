import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/index.dart';
import '../core/server_binding.dart';
import '../pages/o_b_s_settings_page.dart';

class OBSServerConnectionButtonWidgetCupertino extends StatelessWidget {
  const OBSServerConnectionButtonWidgetCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return RSIButtonOutlined(
      onTap: () async {
        await Get.to<OBSSettingsPage>(
          () => const OBSSettingsPage(
            key: ValueKey<String>('Settings page'),
          ),
          binding: ServerBinding(),
          transition: Transition.upToDown,
          // curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 500),
        );
      },
      edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
      child: Icon(
        Icons.lock_open_outlined,
        size: 40,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }

  // Future<void> showDialogIos({required BuildContext context}) async {
  //   final AuthObsFormController formController = Get.find();
  //   await Get.defaultDialog<dynamic>(
  //     titlePadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  //     title: AppText.obsServerForm.label,
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  //     content: Column(
  //       children: [
  //         Form(
  //           key: formController.settingsFormKey,
  //           child: Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       SettingsEnum.ip.label,
  //                       style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
  //                       textAlign: TextAlign.left,
  //                     ),
  //                     CupertinoTextField(
  //                       // obscureText: true,
  //                       controller: formController.textEditingControllerIp,
  //                       placeholder: '192.XXX.XXX.XXX',
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       SettingsEnum.port.label,
  //                       style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
  //                       textAlign: TextAlign.left,
  //                     ),
  //                     CupertinoTextField(
  //                       // obscureText: true,
  //                       controller: formController.textEditingControllerPort,
  //                       placeholder: '1234',
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       SettingsEnum.password.label,
  //                       style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
  //                       textAlign: TextAlign.left,
  //                     ),
  //                     CupertinoTextField(
  //                       // obscureText: true,
  //                       controller: formController.textEditingControllerPassword,
  //                       placeholder: 'OBS Websocket Password',
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //     confirm: Padding(
  //       padding: const EdgeInsets.all(8),
  //       child: TextButton(
  //         onPressed: () => formController.submit(
  //           onSuccess: (_) {},
  //           onFailure: (_) {},
  //         ),
  //         child: const Icon(
  //           Icons.check,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //     cancel: Padding(
  //       padding: const EdgeInsets.all(8),
  //       child: TextButton(
  //         onPressed: () => Navigator.of(context).pop(),
  //         child: const Icon(
  //           Icons.cancel,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
