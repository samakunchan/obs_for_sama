import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/widgets/error_message_screen.dart';
import 'package:obs_for_sama/widgets/o_b_s_action_buttons.dart';
import 'package:obs_for_sama/widgets/o_b_s_list_scenes.dart';
import 'package:obs_for_sama/widgets/o_b_s_list_sources.dart';
import 'package:obs_for_sama/widgets/o_b_s_server_connection_button_widget.dart';
import 'package:obs_for_sama/widgets/o_b_s_server_connection_button_widget_cupertino.dart';

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
              const OBSActionButtons(
                key: ValueKey<String>('Actions Buttons'),
              ),

              /// DIVIDER
              // const VerticalDivider(),
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
                Expanded(
                  child: Column(
                    children: [
                      ErrorMessageScreen(
                        message: controller.obsStatusMessage.value,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Platform.isAndroid
                            ? const OBSServerConnectionButton(
                                key: ValueKey<String>('Android Button connection'),
                              )
                            : const OBSServerConnectionButtonWidgetCupertino(
                                key: ValueKey<String>('IOS Button connection'),
                              ),
                      ),
                    ],
                  ),
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
