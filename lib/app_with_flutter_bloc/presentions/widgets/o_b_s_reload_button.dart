import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/bloc/server_bloc.dart';
import 'package:obs_for_sama/core/index.dart';

class OBSReloadButton extends StatelessWidget {
  const OBSReloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RSIButtonOutlined(
      onTap: () {
        context.read<ServerBloc>().add(ServerReloaded());
      },
      edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
      child: Icon(
        Icons.refresh,
        size: 40,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
