import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controllers/obs/server_controller.dart';
import '../core/index.dart';

class OBSToogleStreamButton extends StatelessWidget {
  const OBSToogleStreamButton({super.key});

  @override
  Widget build(BuildContext context) {
    final ServerController controller = Get.find();

    return Obx(
      () {
        if (controller.isStreamStarted.value == StatusStream.started) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: RSIButtonOutlined(
              color: Colors.red,
              onTap: controller.stopStreaming,
              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
              text: AppText.stop.label,
            ),
          );
        }
        if (controller.isStreamStarted.value == StatusStream.isStopping) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: RSIButtonOutlined(
              color: Colors.red,
              onTap: controller.stopStreaming,
              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
              text: AppText.isStopping.label,
            ),
          );
        }
        if (controller.isStreamStarted.value == StatusStream.stopped) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: RSIButtonOutlined(
              onTap: controller.startStreaming,
              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
              text: AppText.start.label,
            ),
          );
        }
        if (controller.isStreamStarted.value == StatusStream.isStarting) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: RSIButtonOutlined(
              onTap: controller.startStreaming,
              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
              text: AppText.isStarting.label,
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8),
          child: RSIButtonOutlined(
            onTap: () {},
            edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
            text: AppText.undefined.label,
          ),
        );
      },
    );
  }
}
