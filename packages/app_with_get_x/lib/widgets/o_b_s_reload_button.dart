import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controllers/obs/server_controller.dart';
import '../core/index.dart';

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
