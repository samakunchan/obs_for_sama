import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/clippers.dart';
import 'package:obs_for_sama/widgets/r_s_i_button_outlined.dart';

class OBSServerConnectionButton extends StatelessWidget {
  const OBSServerConnectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RSIButtonOutlined(
      onTap: () async {
        await Navigator.pushNamed(context, '/settings');
      },
      edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
      child: Icon(
        Icons.login,
        size: 40,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
