import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/app_with_get_x/core/controllers/obs/sound_controller.dart';
import 'package:obs_for_sama/core/index.dart';

class OBSToogleSoundButton extends StatelessWidget {
  const OBSToogleSoundButton({super.key});

  @override
  Widget build(BuildContext context) {
    final SoundController controller = Get.find();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: RSIButtonOutlined(
        onTap: controller.toogleMuteSound,
        edgeClipper: const RSIEdgeClipper(
          edgeRightTop: true,
          edgeLeftBottom: true,
        ),
        child: Obx(
          () => controller.isSoundMuted.value
              ? Icon(
                  Icons.volume_off,
                  size: 40,
                  color: Theme.of(context).colorScheme.outline,
                )
              : Icon(
                  Icons.volume_up_sharp,
                  size: 40,
                  color: Theme.of(context).colorScheme.outline,
                ),
        ),
      ),
    );
  }
}
