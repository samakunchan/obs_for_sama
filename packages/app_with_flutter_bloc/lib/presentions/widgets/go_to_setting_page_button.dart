import 'package:flutter/material.dart';

import '../../core/paints/clippers.dart';
import '../../core/widgets/r_s_i_button_outlined.dart';

class GoToSettingPageButton extends StatelessWidget {
  const GoToSettingPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RSIButtonOutlined(
      onTap: () async {
        await Navigator.pushNamed(context, '/settings');
      },
      edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
      child: Icon(
        Icons.settings,
        size: 40,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
