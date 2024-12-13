import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/constantes.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/widgets/r_s_i_button_outlined.dart';

class OBSServerConnectionButton extends StatelessWidget {
  const OBSServerConnectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServerController());

    return RSIButtonOutlined(
      onTap: () async {
        await showDialog(context: context, controller: controller);
      },
      edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
      child: Icon(
        Icons.settings,
        size: 40,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }

  Future<void> showDialog({
    required BuildContext context,
    required ServerController controller,
  }) async {
    await Get.defaultDialog<dynamic>(
      titlePadding: const EdgeInsets.only(top: 25, left: 16, right: 16),
      radius: 5,
      backgroundColor: kPrimaryColor,
      title: AppText.obsServerForm.label,
      titleStyle: kheadlineMedium,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      content: Column(
        children: [
          Form(
            key: controller.settingsFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    obscureText: true,
                    controller: controller.textEditingControllerIp,
                    // placeholder: '192.XXX.XXX.XXX',
                    decoration: InputDecoration(labelText: SettingsEnum.ip.label),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    obscureText: true,
                    controller: controller.textEditingControllerPort,
                    // placeholder: '1234',
                    decoration: InputDecoration(labelText: SettingsEnum.port.label),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    obscureText: true,
                    controller: controller.textEditingControllerPassword,
                    // placeholder: 'OBS Websocket Password',
                    decoration: InputDecoration(labelText: SettingsEnum.password.label),
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
          onPressed: controller.submit,
          child: const Icon(Icons.check, color: Colors.white),
        ),
      ),
      cancel: Padding(
        padding: const EdgeInsets.all(8),
        child: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(Icons.cancel, color: Colors.white),
        ),
      ),
    );
  }
}
