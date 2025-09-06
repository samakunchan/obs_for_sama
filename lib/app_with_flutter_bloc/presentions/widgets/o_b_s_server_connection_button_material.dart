import 'package:flutter/material.dart';
import 'package:obs_for_sama/core/index.dart';

class GoToSettingPage extends StatelessWidget {
  const GoToSettingPage({super.key});

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
