import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/widgets/r_s_i_button_outlined.dart';

class OBSServerConnectionButtonWidgetCupertino extends StatelessWidget {
  const OBSServerConnectionButtonWidgetCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServerController());

    return RSIButtonOutlined(
      onTap: () async {
        await showDialogIos(context: context, controller: controller);
      },
      edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
      child: Icon(
        Icons.settings,
        size: 40,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }

  Future<void> showDialogIos({required BuildContext context, required ServerController controller}) async {
    await Get.defaultDialog<dynamic>(
      titlePadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      title: AppText.obsServerForm.label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      content: Column(
        children: [
          Form(
            key: controller.settingsFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SettingsEnum.ip.label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                      CupertinoTextField(
                        // obscureText: true,
                        controller: controller.textEditingControllerIp,
                        placeholder: '192.XXX.XXX.XXX',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SettingsEnum.port.label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                      CupertinoTextField(
                        // obscureText: true,
                        controller: controller.textEditingControllerPort,
                        placeholder: '1234',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SettingsEnum.password.label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                      CupertinoTextField(
                        // obscureText: true,
                        controller: controller.textEditingControllerPassword,
                        placeholder: 'OBS Websocket Password',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      confirm: Padding(
        padding: const EdgeInsets.all(8),
        child: TextButton(
          onPressed: () => controller.submit(
            onSuccess: (_) {},
            onFailure: (_) {},
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
          ),
        ),
      ),
      cancel: Padding(
        padding: const EdgeInsets.all(8),
        child: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.cancel,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
