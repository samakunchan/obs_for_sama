import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/app_with_get_x/core/controllers/obs/server_controller.dart';
import 'package:obs_for_sama/core/index.dart';

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
