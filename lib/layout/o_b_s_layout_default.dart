import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/widgets/error_message_screen.dart';
import 'package:obs_for_sama/widgets/o_b_s_action_buttons.dart';
import 'package:obs_for_sama/widgets/o_b_s_list_scenes.dart';
import 'package:obs_for_sama/widgets/o_b_s_list_sources.dart';

class OBSLayoutDefault extends StatelessWidget {
  const OBSLayoutDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final ServerController controller = Get.find();
    initialization(controller: controller);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// ACTIONS BOUTONS
              OBSActionButtons(
                key: const ValueKey<String>('Actions Buttons'),
                controller: controller,
              ),

              /// DIVIDER
              const VerticalDivider(),
              if (controller.isOBSSynchronized.value)
                const Expanded(
                  flex: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// SCENES
                      OBSListScenes(
                        key: ValueKey<String>('List Of Scenes'),
                      ),
                      VerticalDivider(),

                      /// SOURCES
                      OBSListSources(
                        key: ValueKey<String>('List Of Sources'),
                      ),
                    ],
                  ),
                )

              /// ERROR MESSAGE
              else
                ErrorMessageScreen(
                  message: controller.obsStatusMessage.value,
                ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> initialization({required ServerController controller}) async {
    await controller.connectToOBS();
    await controller.listenAllStatesFromOBS();
  }
}
