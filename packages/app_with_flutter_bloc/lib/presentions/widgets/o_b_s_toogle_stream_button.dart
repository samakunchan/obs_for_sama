import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../core/index.dart';
import '../../features/o_b_s_status/bloc/o_b_s_status_bloc.dart';

class OBSToogleStreamButton extends StatelessWidget {
  const OBSToogleStreamButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OBSStatusBloc, OBSStatusState>(
      builder: (BuildContext context, OBSStatusState state) {
        if (kDebugMode) {
          print('OBSToogleStreamButton - $state');
        }
        String message = AppText.start.label;
        Color? color;
        VoidCallback? onTapped;
        switch (state) {
          case OBSStatusIsStopping():
            message = AppText.isStopping.label;
            color = Colors.red;
          case OBSStatusHasStarted():
            message = AppText.stop.label;
            color = Colors.red;
            onTapped = () {
              context.read<OBSStatusBloc>().add(OBSStatusStreamStopped());
            };
          case OBSStatusIsStarting():
            message = AppText.isStarting.label;
          case OBSStatusInitial():
          case OBSStatusHasStopped():
            message = AppText.start.label;
            onTapped = () {
              context.read<OBSStatusBloc>().add(OBSStatusStreamStarted());
            };
        }

        return Padding(
          padding: const EdgeInsets.all(8),
          child: RSIButtonOutlined(
            height: 25.sp,
            color: color ?? kTextColor,
            onTap: () {
              if (onTapped != null) {
                if (kDebugMode) {
                  print('Je tape');
                }
                onTapped();
              }
            },
            edgeClipper: const RSIEdgeClipper(
              // edgeRightTop: true,
              edgeLeftBottom: true,
              edgeRightBottom: true,
              // edgeLeftTop: true,
            ),
            text: message,
          ),
        );
      },
    );
  }
}
