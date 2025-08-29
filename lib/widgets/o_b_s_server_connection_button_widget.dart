import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/server_binding.dart';
import 'package:obs_for_sama/pages/o_b_s_settings_page.dart';
import 'package:obs_for_sama/widgets/r_s_i_button_outlined.dart';

class OBSServerConnectionButton extends StatelessWidget {
  const OBSServerConnectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RSIButtonOutlined(
      onTap: () async {
        await Get.to<OBSSettingsPage>(
          () => const OBSSettingsPage(
            key: ValueKey<String>('Settings page'),
          ),
          binding: ServerBinding(),
          transition: Transition.rightToLeft,
          curve: Curves.easeInOut,
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
}
