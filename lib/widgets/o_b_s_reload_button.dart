import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/core/controllers/obs/server_controller.dart';
import 'package:obs_for_sama/widgets/r_s_i_button_outlined.dart';

class OBSReloadButton extends StatelessWidget {
  const OBSReloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ServerController controller = Get.put(ServerController());
    return RSIButtonOutlined(
      onTap: controller.reload,
      edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
      child: Icon(
        Icons.refresh,
        size: 40,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
