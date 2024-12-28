import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/widgets/error_message_screen.dart';
import 'package:obs_for_sama/widgets/o_b_s_action_buttons_mobile.dart';
import 'package:obs_for_sama/widgets/o_b_s_list_scenes.dart';
import 'package:obs_for_sama/widgets/o_b_s_list_sources.dart';

class OBSLayoutMobile extends StatefulWidget {
  const OBSLayoutMobile({super.key});

  @override
  State<OBSLayoutMobile> createState() => _OBSLayoutMobileState();
}

class _OBSLayoutMobileState extends State<OBSLayoutMobile> {
  late ServerController controller;
  @override
  void initState() {
    controller = Get.put(ServerController());
    initialization(controller: controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final safeAreaPadding = mediaQuery.padding;
    final screenHeight = mediaQuery.size.height;
    final availableHeight = screenHeight - safeAreaPadding.top - safeAreaPadding.bottom;

    return SafeArea(
      child: SizedBox(
        height: availableHeight * .95,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return Column(
              children: [
                const VerticalDivider(),
                if (controller.isOBSSynchronized.value)
                  const Expanded(
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

                /// ERROR MESSAGES
                else
                  ErrorMessageScreen(message: controller.obsStatusMessage.value),

                /// ACTIONS BOUTONS
                OBSActionButtonsMobile(
                  key: const ValueKey<String>('Page Mobile View'),
                  controller: controller,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> initialization({required ServerController controller}) async {
    await controller.connectToOBS();
    await controller.listenAllStatesFromOBS();
  }
}
