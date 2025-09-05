import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/server/bloc/server_bloc.dart';
import 'package:obs_for_sama/core/index.dart';

class OBSToogleStreamButton extends StatelessWidget {
  const OBSToogleStreamButton({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO Faire un bloc pour le controle du stream, puisque [ServerBloc] sert à vérifier si le stream est en vie ou non.
    // Donc remplacer le bloc ci-dessous.
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (BuildContext context, ServerState state) {
        if (kDebugMode) {
          print('OBSToogleStreamButton - $state');
        }
        if (state is ServerIsLoading) {
          return const CircularProgressIndicator(color: Colors.white);
        }
        if (state is ServerIsConnected) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: RSIButtonOutlined(
              color: Colors.red,
              onTap: () {},
              edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
              text: AppText.stop.label,
            ),
          );
        }

        return const SizedBox();
      },
    );
    // final ServerController controller = Get.find();
    // return Obx(
    //   () {
    //     if (controller.isStreamStarted.value == StatusStream.started) {
    //       return Padding(
    //         padding: const EdgeInsets.all(8),
    //         child: RSIButtonOutlined(
    //           color: Colors.red,
    //           onTap: controller.stopStreaming,
    //           edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
    //           text: AppText.stop.label,
    //         ),
    //       );
    //     }
    //     if (controller.isStreamStarted.value == StatusStream.isStopping) {
    //       return Padding(
    //         padding: const EdgeInsets.all(8),
    //         child: RSIButtonOutlined(
    //           color: Colors.red,
    //           onTap: controller.stopStreaming,
    //           edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
    //           text: AppText.isStopping.label,
    //         ),
    //       );
    //     }
    //     if (controller.isStreamStarted.value == StatusStream.stopped) {
    //       return Padding(
    //         padding: const EdgeInsets.all(8),
    //         child: RSIButtonOutlined(
    //           onTap: controller.startStreaming,
    //           edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
    //           text: AppText.start.label,
    //         ),
    //       );
    //     }
    //     if (controller.isStreamStarted.value == StatusStream.isStarting) {
    //       return Padding(
    //         padding: const EdgeInsets.all(8),
    //         child: RSIButtonOutlined(
    //           onTap: controller.startStreaming,
    //           edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
    //           text: AppText.isStarting.label,
    //         ),
    //       );
    //     }
    //     return Padding(
    //       padding: const EdgeInsets.all(8),
    //       child: RSIButtonOutlined(
    //         onTap: () {},
    //         edgeClipper: const RSIEdgeClipper(edgeRightTop: true, edgeLeftBottom: true),
    //         text: AppText.undefined.label,
    //       ),
    //     );
    //   },
    // );
  }
}
