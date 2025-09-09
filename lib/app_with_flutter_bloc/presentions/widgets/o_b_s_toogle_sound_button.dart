import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:obs_for_sama/app_with_flutter_bloc/features/sound/bloc/sound_bloc.dart';
import 'package:obs_for_sama/core/index.dart';
import 'package:sizer/sizer.dart';

class OBSToogleSoundButton extends StatelessWidget {
  const OBSToogleSoundButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SoundBloc, SoundState>(
      builder: (BuildContext context, SoundState state) {
        if (kDebugMode) {
          print('Button $state');
        }
        switch (state) {
          case SoundHasConfiguration():
            return Padding(
              padding: const EdgeInsets.all(8),
              child: RSIButtonOutlined(
                onTap: () {
                  context.read<SoundBloc>().add(SoundToggled(soundName: state.correctSoundName));
                },
                edgeClipper: const RSIEdgeClipper(
                  edgeRightTop: true,
                  edgeLeftBottom: true,
                ),
                child: Icon(
                  Icons.volume_off,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            );
          case SoundHasNewStatus():
            return Padding(
              padding: const EdgeInsets.all(8),
              child: RSIButtonOutlined(
                height: 25.sp,
                onTap: () {
                  context.read<SoundBloc>().add(SoundToggled(soundName: state.correctSoundName));
                },
                edgeClipper: const RSIEdgeClipper(
                  edgeRightTop: true,
                  edgeLeftBottom: true,
                ),
                child: state.isSoundActive
                    ? Icon(
                        Icons.volume_off,
                        // size: 40,
                        color: Theme.of(context).colorScheme.outline,
                      )
                    : Icon(
                        Icons.volume_up_sharp,
                        // size: 40,
                        color: Theme.of(context).colorScheme.outline,
                      ),
              ),
            );
          default:
            return Padding(
              padding: const EdgeInsets.all(8),
              child: RSIButtonOutlined(
                onTap: () {},
                color: kBodyTextColor,
                edgeClipper: const RSIEdgeClipper(
                  edgeRightTop: true,
                  edgeLeftBottom: true,
                ),
                child: const SizedBox(),
              ),
            );
        }
      },
    );
  }
}
