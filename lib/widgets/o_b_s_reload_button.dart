import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/mvvm/ui_layer/view_models/o_b_s_server_view_model.dart';
import 'package:obs_for_sama/widgets/r_s_i_button_outlined.dart';

class OBSReloadButton extends GetView<OBSServerViewModel> {
  const OBSReloadButton({super.key});

  @override
  Widget build(BuildContext context) {
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
