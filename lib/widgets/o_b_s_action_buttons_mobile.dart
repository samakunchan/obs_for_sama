import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/controllers/server_controller.dart';
import 'package:obs_for_sama/core/enums.dart';
import 'package:obs_for_sama/widgets/o_b_s_reload_button.dart';
import 'package:obs_for_sama/widgets/o_b_s_server_connection_button_widget.dart';
import 'package:obs_for_sama/widgets/o_b_s_server_connection_button_widget_cupertino.dart';
import 'package:obs_for_sama/widgets/o_b_s_toogle_sound_button.dart';
import 'package:obs_for_sama/widgets/o_b_s_toogle_stream_button.dart';

class OBSActionButtonsMobile extends StatelessWidget {
  const OBSActionButtonsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final ServerController controller = Get.find();

    return Padding(
      key: const ValueKey<String>('Actions Buttons Mobile View'),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            return Column(
              children: [
                if (controller.isOBSSynchronized.value)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Titre
                      Text(
                        AppText.title.label,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                /// CONNECT OBS
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Platform.isAndroid
                                        ? const OBSServerConnectionButton()
                                        : const OBSServerConnectionButtonWidgetCupertino(),
                                  ),
                                ),

                                /// REFRESH
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: OBSReloadButton(),
                                  ),
                                ),

                                /// SOUND
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: OBSToogleSoundButton(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// OBS BUTTONS FOOTER
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              /// OBS SETTINGS
                              Expanded(
                                child: OBSToogleStreamButton(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// OBS SETTINGS
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: OBSServerConnectionButton(),
                      ),
                    ],
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
